Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab1KJUJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 15:09:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62463 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab1KJUJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 15:09:39 -0500
Message-ID: <1320955769.1718.8.camel@jupiter>
Subject: 3.2-rc1 doesn't boot on dual socket opteron without swap
From: Niklas Schnelle <niklas@komani.de>
To: linux-kernel@vger.kernel.org
Date: Thu, 10 Nov 2011 21:09:29 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-jQB/rDbO/gM6EQUt7zGB"
X-Mailer: Evolution 3.2.1 
Mime-Version: 1.0
X-Provags-ID: V02:K0:RyvM9bhAgR71kfBQF/yrDVr1jgguiA2K6jr7mnwPOQZ
 paLanJMz21K8v2UPXxjcJk6R+dd3U5da4WwsPVyl9p7vWxf+ov
 c+gmtcCIlvwmsI4e31nqX4S6XmkEJSZcXNaOk4ofDIAKAEejzb
 pKpq+7v9zREYjAyhdD1NpkNYg+wN/s2QBe8C/gq5dEJ8ijic9B
 5sZFWpsvuRiGUNBZ7vyLdwvFvBtFMNyXcx+KPsOYpb4fMmtgdO
 eS3ZY2VNFioxO69gQSI1sStNDJkbBS1Sduu0tAm5zoGZ6i/CZk
 Hg2JalUnxhRC/UivUGrMSdPUjNvp8DKAoTQ7u5AdCC6mVQ4yI9
 t+HPxNowtL+3ulfQhNvw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jQB/rDbO/gM6EQUt7zGB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kernel Hackers,

still can't find the Kernel Bugzilla after the kernel.org troubles and=20
G+ would have felt weired so here comes my bug report.

I'm trying to run Linux 3.2-rc1 on an Arch Linux Box with the following
specs:
- Tyan S8320G Motherboard with Dual Socket Magny Cours Opterons 6128=20
- 16 GB RAM.

I'm getting the following error (sorry for bad picture quality, I can
retry if requested)

http://niklas.sceneproject.org/coding/kernel-3.2-rc1-bug.jpg

The exact same build (from a linux-mainline repository for Arch Linux)
runs well on a friends laptop.
One thing that could play a role is that due to enough RAM I'm running
without swap. It's just so much easier if rampant processes get shot
down by the OOM killer before things get swapping and slow.

Greetings Niklas

--=-jQB/rDbO/gM6EQUt7zGB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJOvC95AAoJEBlEkMMdTRx5fXoQAMO5zsu68fGlHzy1c5LnSmFL
rur5vWLLFA1Yw9MAIAuziWB6D5tChCGzC9w0K/hJ0qpOH3vTZmwWIQbj9/1S0ziZ
thgcgKlXm9+JGZsplenXw3RmuMM2ApRTaBRvKZPo3cJR8gnGTL0IqsNe7LYym4vX
NZsrOaGSkQCwUxAlhM/Y0HtVNFV9nJmuizTF1YZvU4pNa9zBrVRqxpXs0xIg0vRQ
n9DRPjooE6CslYkhCsOrHjZ6nMU2KxFq6vqv6N0Kq+Je5EdDWcJUTdesMR8Ai4PC
D7k1YhVzea3I94/gI0i6KbijnxIrEoONbQ3JjThlfJym8HNiignzWCjDckRjltqv
cXlZhKs79tMrok3BYKbWjMX8CWaIHnWucVUtxxFcTyvvY7keF8QT/v8ECxuGS4YQ
g+DBQpP9AQK5sTECwK94MWI2BMIl6vlOkqDJXJ4oBL5kTFHMEC8emFtiJvIDBCzH
CKA1r9y8AbzJxlEVBSbPY9sUX4wUuAJjeVbfBShSanuKkUrShejNWegPpisKRIlw
NFw2eh4O4ZY9QWKhXEEc0pLjfH1moPui2t2yR6YKiTM6SXHzZFf21X/LG4PF0uV2
qd/3094fGOOc6Vmp7NQAqdoFDmYF9gIvuYTm4LznsSTANa4xELcfsiuiKdmqFqUv
2J/tbwDMOMjsSaZsRaw/
=cECE
-----END PGP SIGNATURE-----

--=-jQB/rDbO/gM6EQUt7zGB--

