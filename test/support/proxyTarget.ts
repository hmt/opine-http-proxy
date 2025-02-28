import { json, opine, urlencoded } from "../deps.ts";

export function proxyTarget(
  { port = 0, handlers }: {
    port?: number;
    handlers?: any;
  } = { port: 0 },
) {
  const target = opine();

  target.use(urlencoded());
  target.use(json());

  if (handlers) {
    handlers.forEach((handler: any) => {
      (target as any)[handler.method](handler.path, handler.fn);
    });
  }

  return target.listen(port);
}
