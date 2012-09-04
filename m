Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab2IDM3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 08:29:12 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:42375
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756982Ab2IDM3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 08:29:10 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz936eI4015Izz1202hzz8275dhz2dh668h839h944hd25hf0ah11b5h121eh1220h1155h)
X-WSS-ID: 0M9TRZG-01-0PG-02
X-M-MSG: 
Date: Tue, 4 Sep 2012 14:28:23 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] oprofile: fixes and updates
Message-ID: <20120904122823.GT8285@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Mailer: git-send-email 1.6.6
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

one patch each for perf/urgent and perf/core, please pull from:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

and

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Thanks,

-Robert


The following changes since commit fea7a08acb13524b47711625eebea40a0ede69a0:

  Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Robert Richter (2):
      oprofile, s390: Fix uninitialized memory access when writing to oprofilefs
      oprofile: Remove 'WQ on CPUx, prefer CPUy' warning

 arch/s390/oprofile/init.c     |   10 +++++-----
 drivers/oprofile/cpu_buffer.c |   11 +++--------
 2 files changed, 8 insertions(+), 13 deletions(-)

