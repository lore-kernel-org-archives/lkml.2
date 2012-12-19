Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab2LSASu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:18:50 -0500
Received: from [65.55.88.14] ([65.55.88.14]:14289 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755101Ab2LSASq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:18:46 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1de0h1202h1e76h1d1ah1d2ahzzz2fh95h668h839hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h906i1155h)
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: <linux-kernel@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        <monstr@monstr.eu>, John Linn <john.linn@xilinx.com>
CC: <git@xilinx.com>, <josh.cartwright@ni.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 0/7] Updates for Zynq's timer driver
Date: Tue, 18 Dec 2012 16:16:32 -0800
X-Mailer: git-send-email 1.8.0.2
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <bfaf054c-2b45-458e-a67f-f9d1c982ec51@TX2EHSMHS017.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I started to put some effort on syncing the Xilinx Linux tree with mainline and
the timer driver is my first victim.
Most commits are fixing style issues or clean up. Functionality is touched only
in patches #2 and #7.

Some patches are present in almost identically in the Xilinx Linux tree and I
took over 'Ackec-by' lines from those commits.

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


