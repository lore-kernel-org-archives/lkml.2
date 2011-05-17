Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab1EQDOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 23:14:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36892 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab1EQDOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 23:14:37 -0400
Date: Tue, 17 May 2011 13:14:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Hellstrom <daniel@gaisler.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: manual merge of the tip tree with the sparc tree
Message-Id: <20110517131435.aceca54e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__17_May_2011_13_14_35_+1000_MrVcW=sTA_dQC=2x"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_May_2011_13_14_35_+1000_MrVcW=sTA_dQC=2x
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/sparc/kernel/smp_32.c between commit d6d048192b1d ("sparc32:
implement SMP IPIs using the generic functions") from the sparc tree and
commit 184748cc50b2 ("sched: Provide scheduler_ipi() callback in response
to smp_send_reschedule()") from the tip tree.

I fixed it up (I am pretty sure that the sparc tree patch supercedes the
tip tree one) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__17_May_2011_13_14_35_+1000_MrVcW=sTA_dQC=2x
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN0egbAAoJEDMEi1NhKgbs8LoH/0fn7q0ZF+Gj1KgQ6juioznc
qIrZO8UWTW4VFCw22eq5PKg3gX3ym5uRx2J2offbUkIGdvRrbYbQZx8zn1wKe+P0
l2DwB1/Q7LfTAERaD5VnjXTquE3zjiBn2swo7iy1IdH6kOdkVbnNY4s9hdaNhlZG
weGEg+HWPUEQPmd6v9IgYNCuvtvDOhKblTbNJ4V+e7r11dONQdgdcAZIOwSoVAmP
qlnLXLJV8BrPskLv7EWlXgKCWYibMuxvohwgyYLSU6S/h047c0xLbls9WhdODFnA
3K0wH/5cLEFmTfhqudEM0wn7tCEVZgeLKGmEvgY+6tl0So6x04hNLVK59B7A61w=
=AIMO
-----END PGP SIGNATURE-----

--Signature=_Tue__17_May_2011_13_14_35_+1000_MrVcW=sTA_dQC=2x--
