Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab1EaATs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 20:19:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44639 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab1EaATr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 20:19:47 -0400
Date: Tue, 31 May 2011 10:19:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Borislav Petkov <bp@alien8.de>
Subject: linux-next: manual merge of the tip tree with the  tree
Message-Id: <20110531101934.2737dc90.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__31_May_2011_10_19_34_+1000_WL+g+E1LTn+h.yyA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__31_May_2011_10_19_34_+1000_WL+g+E1LTn+h.yyA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/kernel/process.c between commit 8a27ef90237f ("x86 idle: fix
build warning for WARN_ONCE("idle=3Dmwait")") from the idle-test tree and
commit 598e887d8b01 ("x86 idle: Fix mwait deprecation warning message")
from the tip tree.

Slightly different patches for the same warning.  I fixed it up (using
the version from the idle-test tree which is more complete).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__31_May_2011_10_19_34_+1000_WL+g+E1LTn+h.yyA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN5DQWAAoJEDMEi1NhKgbs4XkH/0OH5BmM/aE7TvYwJI9oWddf
ccd7xAyWqt2tV3u50FoK5QMpa1+LG0Mj2iqXIYzBbwc7rt6y4c6dyphK//DCIdNE
oLz8oEcftO9tG6D8zKspxJfHVXXYrgjdsluaS8GFXGLP4fHb6wXU1lnaKvZkBpJh
Lv2AldyiAesN80tf6v1ojs1DrOgbOvmqoPgid/rqTYnyqhwkhZ3KD3PypwuJBDR6
BrT0T8ctNBp7LWyHGvxCPhK7KhDT9hi+MuJbzb3ej1/RK4CTwPTmrp23ma2RLR63
ldhurtyjQCswFHDKD1flmz/g26O/CG/YCoeJfLcEDIBmupgjI5I0hEkuegLqFGA=
=E+2c
-----END PGP SIGNATURE-----

--Signature=_Tue__31_May_2011_10_19_34_+1000_WL+g+E1LTn+h.yyA--
