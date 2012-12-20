Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab2LTUdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 15:33:00 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54017 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2LTUcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 15:32:54 -0500
Date: Thu, 20 Dec 2012 22:32:43 +0200
From: Felipe Balbi <balbi@ti.com>
To: Sasha Levin <sasha.levin@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Du Changbin <changbinx.du@intel.com>,
        Michal Nazarewicz <mina86@mina86.com>, Felipe Balbi <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tools/usb: remove unneeded 'continue' and simplify
 condition
Message-ID: <20121220203242.GC28433@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
 <1356030701-16284-7-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline
In-Reply-To: <1356030701-16284-7-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 20, 2012 at 02:11:15PM -0500, Sasha Levin wrote:
> Basically remove unneeded code. Since that 'continue' is at the end
> of the for() there's no need for it.
>=20
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  tools/usb/testusb.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c
> index 68d0734..643cd77 100644
> --- a/tools/usb/testusb.c
> +++ b/tools/usb/testusb.c
> @@ -507,10 +507,8 @@ usage:
>  			return handle_testdev (entry) !=3D entry;
>  		}
>  		status =3D pthread_create (&entry->thread, 0, handle_testdev, entry);
> -		if (status) {
> +		if (status)
>  			perror ("pthread_create");
> -			continue;
> -		}
>  	}
>  	if (device) {
>  		struct testdev		dev;
> --=20
> 1.8.0
>=20

--=20
balbi

--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ03XqAAoJEIaOsuA1yqREUJAP/jwX2JFx114tnoZL39jQojLg
2D7RYBZvOo5spl8li1yUHhI2OPS7aeXKH9h7JZC0I4l/KRAkAzpdADMv/kA0MfH1
SEKqnpGyXptLz4osInw9O+ySbTPeqWJHblXoYhkK3ckqFNALTsb/IrS7XyN5joeO
ibr6402YOpC+0OIV0GEcxlUgPSYB3qgCl9R42SPDHmz9WcH3qjmqMUAKaJcQhABJ
169U24xweniOOj4DaHkS3nb8Q6tSsm5+s5RnOyf7Kl7aToVyVmyf4poa9f54UpLW
R8fI+boCeUS9WPyndpgy3FPB5wzXrGFA9NvrU4GO0lTl1RPzcNgNSLroNfl867KY
TxkadLtiBphVg/1K//BYkiURBJJQYFftiH7ekjUymw3qrnLMh5C2IMt6opVbxIsE
8Ira2a/ieD4Op9JvhSuvxrDN4kDmv9bqhxyycwdtCXBunGkxwcj2LMLIAJwY5DTo
qgj5edWQHTjjyCYdj3SXvfaawcLsuxR5E8FJZNjjctBuxknKLJ8xxtYEOBKFeAtP
duVghxi5tc3KebUrgxGnBEZWZAH+7Pn2d+5jdpjEVmlhcj+xdq23GlbY6730b9qW
LESBYFyQlz0kQx9A7Ht4C0aogUwoBSkG/t/l415hg/BDVaecfQ06oxpnJN7nuCO2
DlH2PtCpPFMYayJ+lZZE
=+Fgs
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--
