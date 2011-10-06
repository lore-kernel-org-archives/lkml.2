Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab1JFCWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 22:22:19 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:49951 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932Ab1JFCWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 22:22:18 -0400
Date: Thu, 6 Oct 2011 13:22:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20111006132204.29c84ed7349daf8c4aa39c3b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Oct_2011_13_22_04_+1100_1z5aA06QpYvmsYA."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Oct_2011_13_22_04_+1100_1z5aA06QpYvmsYA.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/codecs/wm_hubs.c: In function 'wm8993_put_dc_servo':
sound/soc/codecs/wm_hubs.c:225:2: error: implicit declaration of function '=
snd_soc_put_volsw_2r' [-Werror=3Dimplicit-function-declaration]
sound/soc/codecs/wm_hubs.c: At top level:
sound/soc/codecs/wm_hubs.c:365:1: error: 'snd_soc_get_volsw_2r' undeclared =
here (not in a function)

Caused by commit 0f9887d11e7c ("ASoC: Consolidate use of controls with
custom get/put function").

I have used the sound-asoc tree from next-20111005 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__6_Oct_2011_13_22_04_+1100_1z5aA06QpYvmsYA.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjRDMAAoJEECxmPOUX5FET54P/j29k9mY8SWsQUR3z7MUpEbu
tcC+dZGRuYMHjbAtbWyfHJdxYSi3ckDoz8BZ8sbNqd5ljH3g60BmFooqL500k00h
uf7IyFG489rfd9CE+iEms0AM1yUAp5/sq3ugtkBO0nCLOiQMQt0OmYhwjcRUpRDc
qckmp95SY0s45HQWAam9P5gCOAENp5OJX6rKBQ7+Jst4ffoJXA5pg9NxZRT10DoM
qBHMHQOzNswTjete090LlqYLQ6vwlCleeOXIPE5GBrE7D+tGYOS2+9ptPIgiBjfW
LI6SND5mX3MUxNMkTgfFt4/tQs/rkqvdk3kLw7KRE8LAtjoam+70HfutzcGP+EHV
VEEgY78IrxQSc8om8Iea0LTRhFrnKNLmtSaJiMtdX8z+569HUrSpEOpcBVTUnzLy
z4eTykOSkBg7H2ziCEYuSbf2dcNaDyGg23vo2SHFB/wAx+eSmeOuEAOoQvHohZam
r51l4+eCu3mG/zVJ+WCHeW8FWTVyFSxQz7t2VWqwWTzYfPIa54iK/ET8ZubpZYba
UlOaC0+tH5gtaINRlKWpiMqrwdZmhvSc180z02speAf7onDFDyGQgKrzGgDnbGKT
fvqCEgl5t8mE3DjeRM9aq8yQVGetD2YB4WBCwEFhJ42TFusKBKV+dgw0yxZL0U4C
gIrGYbW/jh+e8NCvwDRU
=Cxeo
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Oct_2011_13_22_04_+1100_1z5aA06QpYvmsYA.--
