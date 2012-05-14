Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab2ENNSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:18:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:60232 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617Ab2ENNS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:18:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="142837334"
Message-ID: <1337001716.2528.56.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBIFS: add crypto lookup field to tree node cache
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 14 May 2012 16:21:56 +0300
In-Reply-To: <alpine.DEB.2.00.1205111323010.17715@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205111323010.17715@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-LaZhxDAxEYqZZoaYXZkJ"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LaZhxDAxEYqZZoaYXZkJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-05-11 at 13:24 +0200, Joel Reardon wrote:
>  struct ubifs_zbranch {
>  	union ubifs_key key;
> @@ -751,6 +752,7 @@ struct ubifs_zbranch {
>  	int lnum;
>  	int offs;
>  	int len;
> +	long long crypto_lookup;
>  };

Why is it "long long" which is 64 bit? What will it contain? Could we
make it unsigned int - we'd waste less RAM then - remember that we
allocate a lot of these structures.

--=20
Best Regards,
Artem Bityutskiy

--=-LaZhxDAxEYqZZoaYXZkJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPsQb0AAoJECmIfjd9wqK0IYEQAIk1esjjLDoaj53RN879un89
DAJZotdsuVkZsoHHx1hIA258dFsHML05I3ZKY82hy0acdYdWFDpfIsvIYDK3f16k
2uNZqVZ9lcRiP2nibViO7fcB2lrIe707BSBRArFL6nN9zl1wqyl1X6amv/hPTxZE
buJrB5g5b/6vgWNIXTUgUToLnAac7DGO9oBJc6bZkUimFedR/T/7EYGkB6B5htPo
q/+9t3tqXNqtCLYT8lkALxUVS2w2hD6rMFNCa/zN2Nsfwh2f0jVAbginPm7ZXkJ/
DPcA9fSFJz9GvkG3b6oP1fjROHjfVuIsaJd73NPMvgnAKOXTRd7Ydf9dy5uKZ/A6
4kgGZ8JEzej6V4hP2+yT7cIkciogNSZqBJ2tlwpx0twEzkVX1d9wro/btpblU3MR
3Ww3wB7KNlvf6sqdXrWEwTnUCkGBB45Y4vBbYIlkIHwq4F7EqjNohWRju55cr8Xj
5THk9VuknCVvy2lbySjkJMtOVInYb7BYlzOJcBMszGLRDhvWZ0mhPkM7cp8XCufn
gdWhohZs7BA5Gmr3GU/LE1UBq63NGbB9iOPpWbMfsn9RFHLk4Uv4hE4sxy4M7EX/
NGR77CLfZNT1SiKk+UEVMJ7ZBuoOAiHtemHhZ4fHQr0elzagaB9kKhuUXPntADoU
LoPenukOam30663asNVb
=dp0H
-----END PGP SIGNATURE-----

--=-LaZhxDAxEYqZZoaYXZkJ--

