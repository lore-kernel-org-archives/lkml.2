Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab2LSSRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 13:17:11 -0500
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:54658
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859Ab2LSSRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 13:17:03 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1de0h1202h1e76h1d1ah1d2ahzzz2fh95h668h839hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h906i1155h)
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>, <monstr@monstr.eu>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        John Linn <john.linn@xilinx.com>, Arnd Bergmann <arnd@arndb.de>,
        <git@xilinx.com>, <nbowler@elliptictech.com>, <josh.cartwright@ni.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 0/7] Updates for Zynq's timer driver
Date: Wed, 19 Dec 2012 10:16:25 -0800
X-Mailer: git-send-email 1.8.0.2
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <ab760e55-61c2-46b0-b899-1935c213536e@CO1EHSMHS026.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I started to put some effort on syncing the Xilinx Linux tree with mainline and
the timer driver is my first victim.
Most commits are fixing style issues or clean up. Functionality is touched only
in patches #2 and #7.

Some patches are present in almost identically in the Xilinx Linux tree and I
took over 'Acked-by' lines from those commits.

To repost the patch with the arm-kernel list included I made this a v2 to avoid
confusion about which series is the current one, though the patches are the same
as the ones posted before on lkml only.
I added Josh's 'Reviewed-by' line though.

v2:
 - extend receipient list
 - adding reviewed by lines to commit messages

	Soren


Soren Brinkmann (7):
  arm: zynq: timer: Replace PSS through PS
  arm: zynq: timer: Remove unnecessary register write
  arm: zynq: timer: Remove unused #defines
  arm: zynq: timer: Align columns
  arm: zynq: timer: Remove redundant #includes
  arm: zynq: timer: Fix comment style
  arm: zynq: timer: Set clock_event cpumask

 arch/arm/mach-zynq/common.c |   6 +-
 arch/arm/mach-zynq/common.h |   2 +-
 arch/arm/mach-zynq/timer.c  | 150 +++++++++++++++++++++-----------------------
 3 files changed, 75 insertions(+), 83 deletions(-)

-- 
1.8.0.2


