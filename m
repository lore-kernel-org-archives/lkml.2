Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab2CSCqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 22:46:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35229 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964825Ab2CSCqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 22:46:08 -0400
Date: Mon, 19 Mar 2012 13:45:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the drm tree
Message-Id: <20120319134558.92dd67a87a2fc0cae5de6a4b@canb.auug.org.au>
In-Reply-To: <20120316135303.7ad016ef3e29eac06027658e@canb.auug.org.au>
References: <20120316135303.7ad016ef3e29eac06027658e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Mar_2012_13_45_58_+1100_X9xSu0AuVsc0jU8n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Mar_2012_13_45_58_+1100_X9xSu0AuVsc0jU8n
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Fri, 16 Mar 2012 13:53:03 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the drm tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>=20
> ERROR: "drm_usb_init" [drivers/gpu/drm/udl/udl.ko] undefined!
> ERROR: "drm_get_usb_dev" [drivers/gpu/drm/udl/udl.ko] undefined!
> ERROR: "drm_usb_exit" [drivers/gpu/drm/udl/udl.ko] undefined!
>=20
> Caused by commit 5320918b9a87 ("drm/udl: initial UDL driver (v4)").
>=20
> I have used the drm tree from next-20120315 for today.

Your attempted fix (commit 2de6d4a9e46c "drm: fix build with UDL if USB
is a module") hasn't worked as I still get the same errors ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__19_Mar_2012_13_45_58_+1100_X9xSu0AuVsc0jU8n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPZp3mAAoJEECxmPOUX5FEtFIP/0cKMKPB+iy6TJucbXu/XIDo
XHLT/UCztp91nilvUYDmoznOYunqUbMqwU/WYcZravDfb/Ccw8nwZf+QugyQiof+
DqDx8qug6JOmc0fdfOhmM9QToR0rkK0oOP+UxUOAXur3GaB7rDUiPzFu6nam2bB5
Nu8g7/n7SLqAfLIHZr9EazVDmKo5/AYVi1fSkbeJPQjKCzd7sjIfnje896PXqCqi
weAoCqtcKAKeK6BxFHZpfJ6LDMZ+ULLo3EToDluRp4KFgWY6+uz6QwrOM9MB+5d/
096fNihyC038QxKf3oBqtqKFaLXylt2L15Rf+B10zQrEAlfMQHVk0l0PshDNWP6L
vg1Bu+rAaSJ3gGPGiOo7cPAntJIN9go4+E4kJuAjDXyBXgQvwQ/P4Na67ReEyW4t
X2HYE+aVNkySdsY8iiCiETQxkRMsgE3/OhBLzItMVYZ/46o7xLXz/6sThz+lYE8Y
WAamVIB0U03I8ivuhIahcp7UyrI9Y+3Zo6hO6AoQESMQ73n4WmCm9EZLajpMuJlH
w/32UQ3BFWykv5i3u6vsmwlg1jr5ENiekX1Ri+3QzVzgqRsk9C5fHS9pZJjhqLgP
MYmIzWfD7qd621zBp2B/0Gg1xMbWxVF2BVOcY2Uvd83C3jMjrD5cHv4lSGFSoXNl
u0nerwnpaV/o4na/TUQW
=xRrR
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Mar_2012_13_45_58_+1100_X9xSu0AuVsc0jU8n--
