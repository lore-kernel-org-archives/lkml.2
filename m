Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab1LSNrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:47:00 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:7760
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346Ab1LSNq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:46:58 -0500
X-SpamScore: -7
X-BigFish: VPS-7(zz936eK4015Lzz1202hzz8275dhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LWGEA3-02-FRY-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Robert Richter <robert.richter@amd.com>
Subject: [GIT PULL] oprofile fixes for 3.2
Date: Mon, 19 Dec 2011 14:46:12 +0100
Message-ID: <1324302373-30872-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull this one fix for 3.2.

Thanks,

-Robert



The following changes since commit dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50:

  Linux 3.2-rc5 (2011-12-09 15:09:32 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Robert Richter (1):
      oprofile: Fix uninitialized memory access when writing to oprofilefs

 arch/s390/oprofile/init.c         |    3 +++
 drivers/oprofile/oprofile_files.c |    9 +++++++++
 drivers/oprofile/oprofilefs.c     |   15 ++++++++++++++-
 3 files changed, 26 insertions(+), 1 deletions(-)

