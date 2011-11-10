Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab1KJBWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 20:22:52 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:59530 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1KJBWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 20:22:51 -0500
Date: Thu, 10 Nov 2011 12:22:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manuel Lauss <manuel.lauss@googlemail.com>
Subject: linux-next: build failure after merge of the mips tree
Message-Id: <20111110122241.eed1e785e4c015a51b9ef585@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__10_Nov_2011_12_22_41_+1100_gB5g=qJCJtF8KR/7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Nov_2011_12_22_41_+1100_gB5g=qJCJtF8KR/7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

After merging the mips tree, today's linux-next build (x86_64
allmodconfig) failed like this:

warning: (SND_SOC_DB1200) selects SND_SOC_AU1XPSC which has unmet direct de=
pendencies (SOUND && !M68K && !UML && SND && SND_SOC && MIPS_ALCHEMY)
warning: (SND_SOC_DB1200) selects SND_SOC_AU1XPSC which has unmet direct de=
pendencies (SOUND && !M68K && !UML && SND && SND_SOC && MIPS_ALCHEMY)
sound/soc/au1x/psc-ac97.c:26:36: fatal error: asm/mach-au1x00/au1000.h: No =
such file or directory
compilation terminated.
sound/soc/au1x/db1200.c:16:36: fatal error: asm/mach-au1x00/au1000.h: No su=
ch file or directory
compilation terminated.
sound/soc/au1x/psc-i2s.c:24:36: fatal error: asm/mach-au1x00/au1000.h: No s=
uch file or directory
compilation terminated.
sound/soc/au1x/dbdma2.c:27:36: fatal error: asm/mach-au1x00/au1000.h: No su=
ch file or directory

[I left the Kconfig lines there just in case they are relevant]

Probably caused by some Kconfig dependency/select change.

I have used the mips tree form next-20111109 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__10_Nov_2011_12_22_41_+1100_gB5g=qJCJtF8KR/7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOuydhAAoJEECxmPOUX5FEJXwQAJ9HhxY8zcsNaM/GEUeK66MV
HyEHGCd/zCUWUZzhQn4mohGjPlu053EFZrh4gYaHn+bUB0uodlTAb1ufy7WEaNyR
zd9AVIvH8rK5rEK+x6LA2qBSFBPRrIo4dKRZbkXBVoKEVS/rZ5ePElvUn5eK+h2C
3f6UbxQWhJEVu4ZOWBarDoo0lIyF7ezVPwsjvdOdnNVBqSlfUGU/Vr0m31GCRlv/
AbSTDzsCCWSXv7QQrbKwGybcVrOh3OMmSRlCqjlLoN1Pl3i4ObKLwm3ZCIeKz/ds
4d9zt0tKwojqjc/XReuLfibg5qMk0VqXO+Qyp8ZzExMUH8EnwkC+r7JhT9+8gyfn
AuxoXGQGCBeMNsq0IJaK8gsMLfg4yHR8SzFKhmlt6rarlR8pwG/vuehjQ2si18Gn
J1pdE1YpoMSiQ3pOy3s9HJ7JT81bLSJrtx79zCegMiLcQtimBh5QG/VuE+fOnoh7
DW6Ch2dkXKDDzAd7a6ijgh41HixY0/Tx4WHTMhKlpxePqDaUG6Pwm04oIXvxc32+
nlF69d9szicx7+wXS5hmijJh0LkxqUmBk5gPcw4Cxk91xnmjlVtYMWpCQ8XEcT21
mJOmBP7svzC6rnWBRfmi4fgAv5vzuMvaufZ+/Ca9wSQ3+F/1s/7GSPmQJd3clD4c
MBAEiSPpuXUT0uGWqqxY
=AeMg
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Nov_2011_12_22_41_+1100_gB5g=qJCJtF8KR/7--
