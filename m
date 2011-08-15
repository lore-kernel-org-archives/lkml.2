Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab1HODHk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 23:07:40 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:33207 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab1HODHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 23:07:36 -0400
X-ASG-Debug-ID: 1313377655-082d21060001-xx1T2L
X-Barracuda-Envelope-From: leoy@marvell.com
From: Leo Yan <leoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <hzhuang1@marvell.com>
Cc: Leo Yan <leoy@marvell.com>
X-ASG-Orig-Subj: [PATCH V4 0/3] ARM: mmp: add audio sram support
Subject: [PATCH V4 0/3] ARM: mmp: add audio sram support
Date: Mon, 15 Aug 2011 11:09:51 +0800
X-ASG-Orig-Subj: [PATCH V4 0/3] ARM: mmp: add audio sram support
Message-Id: <1313377794-26721-1-git-send-email-leoy@marvell.com>
X-Mailer: git-send-email 1.7.4.1
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1313377655
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On mmp platform, there have two sram banks:
audio sram bank, and internal sram bank for video and PM.
So add the sram module to manage these sram banks.

And register the sram banks so can dynamically alloc/free
the buffer.

Leo Yan (3):
  ARM: mmp: add sram allocator
  ARM: mmp: register audio sram bank
  ARM: mmp: register internal sram bank

 arch/arm/Kconfig                      |    1 +
 arch/arm/mach-mmp/Makefile            |    2 +-
 arch/arm/mach-mmp/brownstone.c        |   11 ++
 arch/arm/mach-mmp/include/mach/mmp2.h |   13 +++
 arch/arm/mach-mmp/include/mach/sram.h |   35 +++++++
 arch/arm/mach-mmp/mmp2.c              |    3 +
 arch/arm/mach-mmp/sram.c              |  168 +++++++++++++++++++++++++++++++++
 7 files changed, 232 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-mmp/include/mach/sram.h
 create mode 100644 arch/arm/mach-mmp/sram.c

-- 
1.7.4.1

