Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab2HFQb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 12:31:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59478 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab2HFQb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 12:31:57 -0400
Message-ID: <501FF16E.6020704@kernel.org>
Date: Mon, 06 Aug 2012 09:31:42 -0700
From: Konstantin Ryabitsev <mricon@kernel.org>
Organization: Linux Foundation/Kernel.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: ftpadmin@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: No 3.5 version on www.kernel.org
References: <20120806064856.GA24464@mac.home>
In-Reply-To: <20120806064856.GA24464@mac.home>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1BDE376C17F309FDD261F57B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1BDE376C17F309FDD261F57B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/08/12 11:48 PM, Tino Keitel wrote:
> Hi,
>=20
> when looking at http://www.kernel.org/, kernel 3.4.7 is shown as the
> latest stable kernel, and 3.6-rc1 as the latest mainline kernel. The
> 3.5 version is not mentioned. Why is the latest stable kernel something=

> older than 3.5?

Hi, Tino:

That's due to the way our script currently figures out what needs to go
to the front page. If I understand the code correctly, since there are
no 3.5.x releases, the script goes straight to 3.6-rc and 3.5 doesn't
get mentioned. Let's call that a "feature" until we have a fix. :)

You can, of course, still get 3.5 from
http://www.kernel.org/pub/linux/kernel/v3.x/

Best,
--=20
Konstantin Ryabitsev
Systems Administrator
Linux Foundation, kernel.org
Montr=C3=A9al, Qu=C3=A9bec


--------------enig1BDE376C17F309FDD261F57B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQGcBAEBAgAGBQJQH/FyAAoJEI6WedmufEle770MAIxb8+eHX+2qcTTnPNofG2nt
6KdJTF1G5/3aLuo8iUmdFIzILXZJG2/x6nwF28cH9749IYTOCOyXQops6SStIIj6
shoI+RC9FU2HAYwoY+c9FVxpC/nwARfHHL8B3ZglHPwdbkTA0+VIEmt2VOFXcCI4
/MWKEhsOSf9wZWPyrElXL4sGQtIx8flnH39wIbjW+j5qhROqqr152qsuGEt29iX4
SCgC/s2CJ1mj3uyW9k/POzBv4VMJJKTLZNQixZKg5zONprS6hudMqbidu2WQZF8Q
AReg3dscuwX0B1VdnpqxoRoInfMVnWRQG5byyK2BozJpkF+Kr7fVojQCzJydPZ2M
2PowOIb/SVZrjOs+GIhL6XoI3wq3iVxfF5ybSPSxWxJGN1oMe8rVa97iem3MOhaI
ueJIVVPudijvhBBPtqz8H01AUZQnX2gyrEOjMI8HhVPMijztu3JsVxXUiaMn+cZQ
RMedo87AAiTM4kcK+OAhwu+HHlCf9U9EqkPqIa0ZQg==
=8Uxc
-----END PGP SIGNATURE-----

--------------enig1BDE376C17F309FDD261F57B--
