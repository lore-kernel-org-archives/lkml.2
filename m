Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab1LSBen (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 20:34:43 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:47368 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1LSBek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 20:34:40 -0500
Date: Mon, 19 Dec 2011 12:34:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Breeds <tony@bakeyournoodle.com>
Subject: linux-next: build failure after merge of the hid tree
Message-Id: <20111219123432.f58b93575c90cdbf62a08fbc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Dec_2011_12_34_32_+1100_KSAUh1eEq33P8Xh0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Dec_2011_12_34_32_+1100_KSAUh1eEq33P8Xh0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

After merging the hid tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/hid/Kconfig:37: syntax error
drivers/hid/Kconfig:36: invalid option

Caused by commit 7e69ba7caeb0 ("HID: introduce proper dependency of
HID_BATTERY on POWER_SUPPLY").

I am sure that this "=3D=3D" v. "=3D" in Kconfig files was discussed last
week ... :-(

I have used the hid tree from next-20111216 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__19_Dec_2011_12_34_32_+1100_KSAUh1eEq33P8Xh0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7pSoAAoJEECxmPOUX5FEcs0QAIohxlEAdR4kdYMJIx6q4f9N
u1T7UKMSYS+ONPg5xlV6chA0FbpNyaFH3u3doMfNDUijq7Zr4CapqR2p7anEcmg0
XFPwMdGL0qQ3plNXwHaPlNVGjaqiQ1s4+R92FhOTz8+vjh0OsrxJYd5Cd/7jV6IY
TL905QJEziN2h0N/V/OhlBsPcF270gRj6tBnfNGKMxVWrI9vs0owCc/A6nLRZ6vL
M/Xo7XdWTYhlI5RvpL8+4scO0k0+eZpvII/TSVXtUbTvm80H8cCdAksxuidPttVV
kv+CUGuR+WeS42a6BRd84QsRTnKUQZDlOoQtX0SBSE4MYblgBGUCE3au0z4dWQ0B
7tz7cSxFZr8uDe3675ZFTyKtNkeLtudSYA6pe4UCTiG5dcHmBnBSyPMBcNQsVe5a
BDyOSGjyg0E74roQaKgqxSJCDNIdfw9+DhbImxhWGZWynT4/VvlWija9Fl4RZ0oH
VEPfKVWMyD2bPm6SWe9EZSEsn7ZOsaPs3Up7UMuOKvw4Xmpc4482QvF9EWaEakFt
NOs2ccEYyFgdGoKlqmQtCNDu9nHjju4l5hl4ALZdVBImOvG9bUcR6QIUBwxH9Pil
zCfcE+gLL0r045bhaWrLKUGpyKVjOpQCzSdg/V81AMGLfqTxjtnHCPF29pvCn50j
dKAuF/EtCvnj+Jq9N7aT
=hTWd
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Dec_2011_12_34_32_+1100_KSAUh1eEq33P8Xh0--
