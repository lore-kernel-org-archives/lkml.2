Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab1LSOAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 09:00:34 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:59664 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab1LSOAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 09:00:31 -0500
X-SpamScore: -7
X-BigFish: VPS-7(zz936eK4015Lzz1202hzz8275dhz2dh668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LWGEW7-01-0GH-02
X-M-MSG: 
Date: Mon, 19 Dec 2011 14:59:10 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Robert Richter <robert.richter@amd.com>
Subject: [GIT PULL] oprofile updates for 3.3
Message-ID: <20111219135910.GF16765@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Mailer: git-send-email 1.7.7
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull updates for 3.3:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-tip

Thanks,

-Robert



The following changes since commit 74eec26facadbe6dbc0621bc862892c915c4534f:

  perf tools: Add ability to synthesize event according to a sample (2011-12-12 08:44:00 -0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-tip

Andreas Krebbel (1):
      oprofile, s390: Add event interface to the System z hardware sampling module

Robert Richter (1):
      oprofile: Fix oprofile_timer_exit() breakage

 Documentation/kernel-parameters.txt |    2 +
 arch/s390/oprofile/hwsampler.c      |    7 +-
 arch/s390/oprofile/init.c           |  373 ++++++++++++++++++++++++++++++++---
 arch/s390/oprofile/op_counter.h     |   23 +++
 drivers/oprofile/oprof.h            |    1 -
 5 files changed, 374 insertions(+), 32 deletions(-)
 create mode 100644 arch/s390/oprofile/op_counter.h

