Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab1AaE2I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 23:28:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42501 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab1AaE2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 23:28:06 -0500
Date: Mon, 31 Jan 2011 15:27:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venki@google.com>
Subject: linux-next: build warnings after merge of the tip tree
Message-Id: <20110131152756.0f1b1026.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__31_Jan_2011_15_27_56_+1100_4/R2I5RY=V00dg0e"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__31_Jan_2011_15_27_56_+1100_4/R2I5RY=V00dg0e
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (powerpc
ppc64_defconfig) produced these warnings:

kernel/sched.c:3719: warning: 'irqtime_account_idle_ticks' defined but not =
used
kernel/sched.c:3720: warning: 'irqtime_account_process_tick' defined but no=
t used

Introduced by commit abb74cefa9c682fb38ba86c17ca3c86fed6cc464 ("sched:
Export ns irqtimes through /proc/stat").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__31_Jan_2011_15_27_56_+1100_4/R2I5RY=V00dg0e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNRjpMAAoJEDMEi1NhKgbsUnYIAJc2ipk13OB+L5TLc9hgmMcM
qE5RrjyhH3KaiFM7qSFu3VBjb4DIQsw8ZlOLhzDSy9Gff0zPJ3HxStKEQM3r+R12
b26ETBwZufJcsTeK601eK2++WUv+naX+yJomLtAaEmAseg0Nv3RAtb9v/XxZOnQW
s1pHCsOu/ePSSZxQPI3LjUuAOo8KU63KMjWSJRy94b6BemdNnDWLhaVM113PxZ3F
0zQ7LdB0BJYHgD1iRs6nFbrY0A6NDVCC1KyUw3eEBxtUkIsDO1xLoOfSrqtXM9Kj
YYNiOe7L8YOzlQPr3qEWuuj/5rloLzHeK/pAOgC8VYbYEI/jwAzD2rFBH73JzNk=
=q983
-----END PGP SIGNATURE-----

--Signature=_Mon__31_Jan_2011_15_27_56_+1100_4/R2I5RY=V00dg0e--
