Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab1GDG2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 02:28:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45304 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466Ab1GDG2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 02:28:34 -0400
Date: Mon, 4 Jul 2011 16:28:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Christoph Hellwig <hch@lst.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: linux-next: fixes while rebasing the akpm tree
Message-Id: <20110704162816.fef0b1cb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__4_Jul_2011_16_28_16_+1000_eequDVLOCTI3RHhb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Jul_2011_16_28_16_+1000_eequDVLOCTI3RHhb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

While rebasing the akpm tree onto today's linux-next, I discovered the
following:

The patch hfsplus-add-missing-call-to-bio_put.patch appears to be already
applied (as commit 50176ddefa4a ("hfsplus: add missing call to bio_put()"
from the hfsplus tree).

The patches
x86-mtrr-lock-stop-machine-during-mtrr-rendezvous-sequence.patch,
stop_machine-reorganize-stop_cpus-implementation.patch and
stop_machine-implement-stop_machine_from_inactive_cpu.patch seem to be
already applied (as commits 6d3321e8e2b3 ("x86, mtrr: lock stop machine
during MTRR rendezvous sequence"), fd7355ba1e93 ("stop_machine:
reorganize stop_cpus() implementation") and f740e6cd0cb5 ("stop_machine:
implement stop_machine_from_inactive_cpu()") from the tip tree)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__4_Jul_2011_16_28_16_+1000_eequDVLOCTI3RHhb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOEV2AAAoJEDMEi1NhKgbsvOkIAJA1hlbu9se68fGDzgcn6Uyt
nKe5Ktn1QQ5EYqIaOU18Ky+r0nY3b/i/2Qap9JLiQn6nI1p4PaPwF5UtA5rB8+dd
YtPMHPldEqdCcpTD0qMv6s+8wnI8mKBecXSbttXIjran88IQBL7tHEj9kWz3ejr4
tBBHJ4Z4op40L5M81VFKATva3/5thDZUy4xYMRqksCIiQTf71MiQO6ifqNYW8V5L
a5eJB/f1W/wDndSHcnTFmRzCKTKW68swwkicy1Lb8sptEn3BhU4Rb3Gi2ySS8Lxp
HzyuXze7F88zZOXUABjOo0BWl7zOm1yp/qEJpZj2bYlZnGIaubPpA7izajLA8t8=
=gMjE
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Jul_2011_16_28_16_+1000_eequDVLOCTI3RHhb--
