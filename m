Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab2K0C0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 21:26:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38463 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757910Ab2K0C0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 21:26:36 -0500
Message-ID: <1353983187.4266.40.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 036/270] kbuild: Do not package /boot and /lib in make
 tar-pkg
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Michal Marek <mmarek@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Date: Tue, 27 Nov 2012 02:26:27 +0000
In-Reply-To: <1353949160-26803-37-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
	 <1353949160-26803-37-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ur3K9STa56imb+zTKbeP"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ur3K9STa56imb+zTKbeP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-11-26 at 14:55 -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7u1 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Michal Marek <mmarek@suse.cz>
>=20
> commit fe04ddf7c2910362f3817c8156e41cbd6c0ee35d upstream.
>=20
> There were reports of users destroying their Fedora installs by a kernel
> tarball that replaces the /lib -> /usr/lib symlink. Let's remove the
> toplevel directories from the tarball to prevent this from happening.
>=20
> Reported-by: Andi Kleen <andi@firstfloor.org>
> Suggested-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> [ herton: dropped unrelated changes to arch/x86/Makefile and
>   scripts/Makefile.fwinst, which don't apply anyway on 3.5, see commit
>   3ce9e53e788881da0d5f3912f80e0dd6b501f304 upstream ]
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com=
>

This is missing from 3.4.

Ben.

> ---
>  scripts/package/buildtar |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/scripts/package/buildtar b/scripts/package/buildtar
> index 8a7b155..d0d748e 100644
> --- a/scripts/package/buildtar
> +++ b/scripts/package/buildtar
> @@ -109,7 +109,7 @@ esac
>  	if tar --owner=3Droot --group=3Droot --help >/dev/null 2>&1; then
>  		opts=3D"--owner=3Droot --group=3Droot"
>  	fi
> -	tar cf - . $opts | ${compress} > "${tarball}${file_ext}"
> +	tar cf - boot/* lib/* $opts | ${compress} > "${tarball}${file_ext}"
>  )
> =20
>  echo "Tarball successfully created in ${tarball}${file_ext}"

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-ur3K9STa56imb+zTKbeP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULQk0+e/yOyVhhEJAQqPFw//RKvpf67oitQTZBfcYSPn/rRpbgpvjOXq
EMP7aCCtm1aEyJ9ZhPkOsnghPTzedHoxwK0M/NXcpeE8+HotmCPHclicQPN21qUu
5dS6b309hGcTMbRlJhSe+AOReH/uPtmaRLeQyuRXwa8+a0QWP27aLjKrnMnDZ+ZR
kO+jWde+j+UYpfTrDB9xuhikxcTn95eVjgvB4hfZtDJ/MLdXPr2pm67nnBGJ9Hdy
6slQ0mZXE5/0v3Vsoa+jgK0WPSNoD0eYMlqzUkNFTWYSQf3Eu2MZOawyXZZKJB7b
blg+Xdgge+Hqg4nN52PPXle7N41NMebtydiWNKzM183bw1i/KQpO7pdO1+qhRKJq
Dj9IMsCdxvVfoTGQFR3dpZ00rN0mf6PBTA2jLleSwIdRoTuQ6Nv3VCRr+TEdbDZF
Ru7/z2sE38qq+Lx2lE9SG2oUg+gWe4ix5eP5fjC3gE+8f9oOXUFxNQTlLEo5h/Jg
EAaLEoHsQK7FDGeP6I/Ks37GdQJx0yCZFgnJltGoFqZTWemvOmg3QIzdW368dxmM
0bHwqcNeK1Ys8NnVaoBY2r99b2YFOZp4qP+c2S0sA3NGxuulfofDtebEGkFWz1ld
53mQ4CU9xAcGdCSVwKNzV6F90DuUpinpQqFk3SXQCOAC3mhlcE7bVJE1F6k+Bo/9
VWuddaBNypM=
=G3u7
-----END PGP SIGNATURE-----

--=-ur3K9STa56imb+zTKbeP--
