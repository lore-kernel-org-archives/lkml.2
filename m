Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759793Ab2HXSxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 14:53:55 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:42687
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755183Ab2HXSxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 14:53:50 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839hd24he5bhf0ah11b5h1155h)
X-WSS-ID: 0M99WHI-02-14U-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 0/2] oprofile fixes and updates
Date: Fri, 24 Aug 2012 20:53:29 +0200
Message-ID: <1345834411-24940-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.6
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2 small patches sent out for review.

-Robert

Robert Richter (2):
  oprofile, s390: Fix uninitialized memory access when writing to
    oprofilefs
  oprofile: Remove 'WQ on CPUx, prefer CPUy' warning

 arch/s390/oprofile/init.c     |   10 +++++-----
 drivers/oprofile/cpu_buffer.c |   11 +++--------
 2 files changed, 8 insertions(+), 13 deletions(-)

-- 
1.7.8.6


