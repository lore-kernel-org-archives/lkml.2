Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab1KHQF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:05:26 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:34690
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755158Ab1KHQFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:05:24 -0500
X-SpamScore: -6
X-BigFish: VPS-6(zz936eK4015Lzz1202hzz8275dhz32i668h839h34h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,0,13,
X-WSS-ID: 0LUCNCS-01-7CB-02
X-M-MSG: 
Date: Tue, 8 Nov 2011 17:05:13 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] oprofile updates for v3.2
Message-ID: <20111108160513.GJ12451@erda.amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Ingo,

please pull oprofile fixes for v3.2 (tip/perf/urgent):

  git://amd64.org/linux/rric.git urgent

and oprofile updates for v3.3 (tip/perf/core):

  git://amd64.org/linux/rric.git core

The urgent branch is a subset of core and intended for v3.2. It only
contains patches marked also for stable.

The merge is to resolve conflicts with perf/core.

See also here:

 http://www.amd64.org/gitweb/?p=3Dlinux/rric.git;a=3Dsummary

Commit ids:

 de346b6 Merge branch 'perf/core' into oprofile/master
 dcfce4a oprofile, x86: Reimplement nmi timer mode using perf event
 75c43a2 oprofile: Remove exit function for timer mode
 159a80b oprofile, x86: Add kernel parameter oprofile.cpu_type=3Dtimer
 97f7f81 oprofile, x86: Fix crash when unloading module (nmi timer mode)
 87121ca oprofile: Fix crash when unloading module (hr timer mode)

Thanks,

-Robert



The following changes since commit 886605636e656afeb6fad5e83dbf36967f65cfa5:

  perf report: Add progress bar when processing time ordered events (2011-1=
1-02 12:28:35 -0200)

are available in the git repository at:
  git://amd64.org/linux/rric core

Robert Richter (6):
      oprofile: Fix crash when unloading module (hr timer mode)
      oprofile, x86: Fix crash when unloading module (nmi timer mode)
      oprofile, x86: Add kernel parameter oprofile.cpu_type=3Dtimer
      oprofile: Remove exit function for timer mode
      oprofile, x86: Reimplement nmi timer mode using perf event
      Merge branch 'perf/core' into oprofile/master

 Documentation/kernel-parameters.txt |    3 +
 arch/Kconfig                        |    4 +
 arch/x86/oprofile/Makefile          |    3 +-
 arch/x86/oprofile/init.c            |   25 ++----
 arch/x86/oprofile/nmi_int.c         |   27 ++++-
 arch/x86/oprofile/nmi_timer_int.c   |   50 ----------
 drivers/oprofile/nmi_timer_int.c    |  173 +++++++++++++++++++++++++++++++=
++++
 drivers/oprofile/oprof.c            |   21 ++++-
 drivers/oprofile/oprof.h            |    9 ++
 drivers/oprofile/timer_int.c        |   29 +++---
 kernel/events/core.c                |    2 +
 11 files changed, 252 insertions(+), 94 deletions(-)
 delete mode 100644 arch/x86/oprofile/nmi_timer_int.c
 create mode 100644 drivers/oprofile/nmi_timer_int.c

--=20
Advanced Micro Devices, Inc.
Operating System Research Center

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQEcBAEBAgAGBQJOuVM5AAoJEOpSwMmQLO0f9BIH+weTgw6/TyhzfYBuC8A9t3iK
U6dTPsP3rWuQxd4QBVP+l+80LNSGOoUpN4T/GRPc4qcQrVVSLlZpl9p4sEZMDfNK
4QgaJqvUQcuyXM0VPIrJx/XmLKjQwnzUEOxrf1NbemVyEd6rzZiAq4TANV1A/7ug
Ifs1d+2rKZSfUAti+RIgkxGOS/ApjIKKtOgA0x30Ncl/3v18pTUm0GVPisbqJKdM
/5dwtCFD7WWT6vt0fuRXxZdKNbRY9MKGyuswde1tYNcjhruwrHwOxPtx+ixLGBUz
Uxacvs5W9u0StH12UhtianiVHBAIuk6t/dODUfuJDvO0LBC42q5LjYgZqv3o3VM=
=z06w
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
