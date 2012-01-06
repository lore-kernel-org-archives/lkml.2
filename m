Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266Ab2AFVF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 16:05:28 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:46696 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759162Ab2AFVF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 16:05:26 -0500
Date: Fri, 6 Jan 2012 13:05:23 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI: DEVICE_COUNT_RESOURCE should be equal to
 PCI_NUM_RESOURCES
Message-ID: <20120106130523.2a904776@jbarnes-desktop>
In-Reply-To: <1325720985-6051-1-git-send-email-yinghai@kernel.org>
References: <1325720985-6051-1-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2mwAQqExp68Vbf3BTLA0lk7"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2mwAQqExp68Vbf3BTLA0lk7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed,  4 Jan 2012 15:49:45 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> Save some bytes for device resource array.
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>=20
> ---
>  include/linux/pci.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> Index: linux-2.6/include/linux/pci.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/include/linux/pci.h
> +++ linux-2.6/include/linux/pci.h
> @@ -111,7 +111,7 @@ enum {
>  	PCI_NUM_RESOURCES,
> =20
>  	/* preserve this for compatibility */
> -	DEVICE_COUNT_RESOURCE
> +	DEVICE_COUNT_RESOURCE =3D PCI_NUM_RESOURCES,
>  };
> =20
>  typedef int __bitwise pci_power_t;

Not sure what this buys us by itself, but it's applied in preparation
for any upcoming cleanups.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/2mwAQqExp68Vbf3BTLA0lk7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPB2ITAAoJEIEoDkX4Qk9hay8QAK1iVFB+3e4WgDefioNNHmAP
nCu9ntqu0TUkbVdyzqjeVe04hn7e6e8DEMuAlSQD37tPQPEQuLCoXkii7/GV0/1T
ePSqRth6fq1LW3omNP6EVcY36Z+y0Di4x3hgd6JQbU3AiR+qCpfGTeJ6TAZg7yKb
jzBDPhRvZMZqp2gnNq+8yienS+2lsQZejzOLXnWmDLmI4WYRMeUde/I3Ircg+dCk
WOVDKgQTtFxnMvJmOi3sdOyRUy+OSlvDubV0H7g7mqlWWQtHIGv1FT0q4BFbb/FU
grboQ0jswYDJTM+tZkPHWE+IXEYdNEapSVjuDI07n7lqAX9dcKr18gNugPW0ry9q
H3GXQD71CBONrCgDiGWmSZOMShfFPB9oOv5bCoVrcXiDXoOXafIklqdhA8HYKvkB
RHIlT8W+f3BmQGYmyV+1x9qoyGWPlLHTjEYipgOPuPJmZrkxB+mZRrJbqdR9Syrp
5TVhXKfFvUwSHtey4gEJ0caSBIAuZC8b/xlb41zc0p9mv/6lsLh1aafPa3I7TK1w
+ZlmW1VEuWdtM7EZkv8X6cjA8x/9lp9l/XTriuKp+Um4HUzxjiJ5SNUPyfkwlb1c
5MW4pYY5/JY+wMxk1lcxzxI4G8Upp9S0wtWipoxQhK48ZXJnWhsqyO47cZ4dyaGh
bYWvlGd7Hg7kFzNYnTB+
=zRJh
-----END PGP SIGNATURE-----

--Sig_/2mwAQqExp68Vbf3BTLA0lk7--
