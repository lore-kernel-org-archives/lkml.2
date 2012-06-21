Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab2FUPId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 11:08:33 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:26325
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757807Ab2FUPIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 11:08:32 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz936eI4015Izz1202hzz8275dhz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5Z3E0-01-7BK-02
X-M-MSG: 
Date: Thu, 21 Jun 2012 17:08:20 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Will Deacon <will.deacon@arm.com>
Subject: [GIT PULL] oprofile: fixes for tip/perf/urgent
Message-ID: <20120621150820.GB24632@erda.amd.com>
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

it's only one patch, please pull from:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Thanks,

-Robert


The following changes since commit 6921a575c9f26f7ea274aaea3b78967810ce5513:

  Merge branch 'tip/perf/urgent-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into perf/urgent (2012-06-20 14:26:58 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Will Deacon (1):
      oprofile: perf: use NR_CPUS instead or nr_cpumask_bits for static array

 drivers/oprofile/oprofile_perf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

