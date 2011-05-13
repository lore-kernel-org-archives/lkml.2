Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1EMDLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 23:11:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48933 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab1EMDK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 23:10:58 -0400
Date: Fri, 13 May 2011 13:10:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the tip tree with the  tree
Message-Id: <20110513131044.499e82d0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__13_May_2011_13_10_44_+1000_vEePqgvS0QWd4Eh3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__13_May_2011_13_10_44_+1000_vEePqgvS0QWd4Eh3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/mips/kernel/i8253.c between commit 2b9b7cd782a5 ("clocksource:
convert mips to generic i8253 clocksource") from the arm tree and commit
75c4fd8c7862 ("mips: convert to clocksource_register_hz/khz") from the
tip tree.

The former seems to supercede the latter, so I used the former.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__13_May_2011_13_10_44_+1000_vEePqgvS0QWd4Eh3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNzKE0AAoJEDMEi1NhKgbsPWYH/RlzCk59DUAB8GFYwzIW4imO
m9VBnMscNSad9Pwrl7AC2IrWs6Z6Fc0E8hT2KvWNepmOUa/vl2mkWd4AKigkX7l5
3YrJTjNQCDIWTtr5cQO9c0K6nMJzURrNXTO4IZ9Hh0UnsIUKY9KMgv2cVCxaqHt7
HuANKCZ+nkd/bOmB1R32Cjjulx4BCs/sfOuodik8VNtGd1Baxiq82ex1bvgQ43b/
qZE/NRHpJ8NmtBPV14VBBcRhDcP7lT9LxfkEGh08yeTLscraHUS3l2xUElnAYBhj
qINHkcv7YEJRqouxBAmixiGZD+b1MwfMcRckp/NWDQW7L0+T+VXZgUWX6JOrUQY=
=mHKg
-----END PGP SIGNATURE-----

--Signature=_Fri__13_May_2011_13_10_44_+1000_vEePqgvS0QWd4Eh3--
