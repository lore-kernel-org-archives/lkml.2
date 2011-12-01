Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab1LADkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 22:40:06 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:40838 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab1LADkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 22:40:04 -0500
Date: Thu, 1 Dec 2011 14:39:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>, Thomas Meyer <thomas@m3y3r.de>,
        Jiri Kosina <jikos@jikos.cz>
Subject: linux-next: manual merge of the staging tree with the hid tree
Message-Id: <20111201143952.9aea929b16c7212570fc1bd2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__1_Dec_2011_14_39_52_+1100_E7+8XVwWkvx.A0Y3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Dec_2011_14_39_52_+1100_E7+8XVwWkvx.A0Y3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/hid/hid-hyperv.c between commit b95f5bcb811e ("HID: Move the
hid-hyperv driver out of staging") from the hid tree and various commits
from the staging tree (this was drivers/staging/hv/hv_mouse.c).

The commit message says that all the changes that happened when this file
moved from staging have also been applied to the staging file, so I just
used the version from the hid tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__1_Dec_2011_14_39_52_+1100_E7+8XVwWkvx.A0Y3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO1vcIAAoJEECxmPOUX5FEphIP/1a4i9jUKKjWqQc6mwxw6J/c
wgxrdYlhQVmCZXbSxkQtMOUo7eqndsVsauU34d2CEsfRyZXaUcmKwzDeG0dkIvRZ
Qg2NOnw8Tj+N1xmSguvvjLJX1wlS5sUYJk8e3c06qG6PAdDop7foaCPUh0KA2wpI
AO8NJdLTX4Dm4fVVFVUXPQExguqP/5Cyl+H7By+pEVLXzyaFrR1wJZDJ+SNCtA3W
mHf6lkqx5Rgyj30HIeZj0edbRih2FNihL7+hpz86HO5Mjdf0HuDiacBnjmpdN1oQ
BQ6SqiwsY4T6GkyoSSkl2ySHNhwg0EqGuqntuoK5ptDfDiigVSYroTI7wXnhYDbQ
8XWyt16oZGwSbozFfi6+hxv1N2v/X+70kghWaGKtm32dS59PUq6L3bg9314tYVcD
ZLi4uxvTdVILYM3yqWz85AOGeWQh79Hg0lkd7z2mYskn38CV15GoGlpBi78vf5iu
HW646Mop8pEIG2zPlXcQWulzQ/UyhYFhLNW8wFFiy9wloC/UXAbSY0Wsh0AJnDMP
v3oc23hJC8QSJWUHWYc25Dx7xoUDTWieE/QpSzazpljQYCLd987Oa0MlC21OTkHe
040HSR2furTuzdDUcQSKw5pRBAfxJ/+z5BAl2xqwfCLBSJWES/TTEk4fi7kDOG+P
SxT3bY0/HkvjX0o2ip2w
=P/q+
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Dec_2011_14_39_52_+1100_E7+8XVwWkvx.A0Y3--
