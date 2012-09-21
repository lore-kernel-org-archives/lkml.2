Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab2IUJiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:38:04 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:58378 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932897Ab2IUJiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:38:00 -0400
Date: Fri, 21 Sep 2012 12:33:11 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 02/25] userns: Convert gadgetfs to use kuid and kgid
 where appropriate
Message-ID: <20120921093309.GB15626@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
 <1348141326-23355-2-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IiVenqGWf+H9Y6IX"
Content-Disposition: inline
In-Reply-To: <1348141326-23355-2-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 20, 2012 at 04:41:43AM -0700, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
>=20
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Felipe Balbi <balbi@ti.com>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/gadget/inode.c |    4 ++--
>  init/Kconfig               |    1 -
>  2 files changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
> index e58b164..7bd36c8 100644
> --- a/drivers/usb/gadget/inode.c
> +++ b/drivers/usb/gadget/inode.c
> @@ -1988,8 +1988,8 @@ gadgetfs_make_inode (struct super_block *sb,
>  	if (inode) {
>  		inode->i_ino =3D get_next_ino();
>  		inode->i_mode =3D mode;
> -		inode->i_uid =3D default_uid;
> -		inode->i_gid =3D default_gid;
> +		inode->i_uid =3D make_kuid(&init_user_ns, default_uid);
> +		inode->i_gid =3D make_kgid(&init_user_ns, default_gid);
>  		inode->i_atime =3D inode->i_mtime =3D inode->i_ctime
>  				=3D CURRENT_TIME;
>  		inode->i_private =3D data;
> diff --git a/init/Kconfig b/init/Kconfig
> index 60bdff2..633bde2 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -932,7 +932,6 @@ config UIDGID_CONVERTED
>  	depends on NET_9P =3D n
> =20
>  	# Filesystems
> -	depends on USB_GADGETFS =3D n
>  	depends on USB_FUNCTIONFS =3D n
>  	depends on DEVTMPFS =3D n
>  	depends on XENFS =3D n
> --=20
> 1.7.5.4
>=20

--=20
balbi

--IiVenqGWf+H9Y6IX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQXDRVAAoJEIaOsuA1yqREFZEP/3dSDMzw9UcpqlcxgT8IdZnT
/u0tjP0KIkPCRAXYSYmRuh991WAqWX5qXk/x+plpX9VoLSp57lSY9Sh7ITLtnCc1
J2ksZTxlDT57pIBQpSK0UL9/FiIa9yjdWyAHgLj5YAXW8YWGYAFEQ2UiPJE1i4O7
pJYUna2xHEZKQAm+n4dJAcohWM2P2fWPIb9z3fVDJow8Q3CNrh/wSDl1HZpGd5ls
ga5NMV3zfU1uv4dVkQKzbobbbfpAqWUTE0xLSGvfT0uamctL033VJNdx6+KlH+gG
o1H6tNlqUgPKo+EoN9t3zXqOtzOPTIv5VxVbaKsV4WuzyTT7ASSBmMej5mAUIeuJ
aHlAP0Mbc4ykEatBahWDHmwuyswTK4Z6RN8d31kju4pKEzN7rix+5NW7Z/Ckwn+X
tcZston16u8tz5Jt2LjapOGhckf6ZhWhdzTz0cji4iMSjTz6AvrKDwlGSlJtVCU5
xR4zE0Otic7s1OSKeDKTO7m8yOLYn6+dBrI3MtuO9nj25vIEXXvHjEe+HdJYEpKS
VilAt3CDA9o+NbmLF9OKV+BIyfenXs61QkCIk2VRVs0Fkt18O2ekuSPjGvUM/ZNv
cslx5GnofRgpFgyY7MVwUgNjM45YIa98A3Wur0AvfJAcdyURoKOK1BWaopzyGUcm
wdr+/4aIq+xv8deA//L9
=w3Zf
-----END PGP SIGNATURE-----

--IiVenqGWf+H9Y6IX--
