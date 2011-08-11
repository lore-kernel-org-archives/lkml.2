Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab1HKC3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 22:29:48 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:38656 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1HKC3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 22:29:46 -0400
X-ASG-Debug-ID: 1313029786-082d18940001-xx1T2L
X-Barracuda-Envelope-From: leoy@marvell.com
From: Leo Yan <leoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hzhuang1@marvell.com, nicolas.pitre@linaro.org, linux@arm.linux.org.uk,
        plagnioj@jcrosoft.com
Cc: Leo Yan <leoy@marvell.com>
X-ASG-Orig-Subj: [PATCH V3 0/2] ARM: mmp: add audio sram support
Subject: [PATCH V3 0/2] ARM: mmp: add audio sram support
Date: Thu, 11 Aug 2011 10:31:59 +0800
X-ASG-Orig-Subj: [PATCH V3 0/2] ARM: mmp: add audio sram support
Message-Id: <1313029921-32227-1-git-send-email-leoy@marvell.com>
X-Mailer: git-send-email 1.7.4.1
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1313029786
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On mmp platform, there have several sram banks for
audio, video and PM. So add the sram module to manage
these sram banks.

And register audio sram bank for allocating to versatile
pcm devices.

Leo Yan (2):
  ARM: mmp: add sram allocator
  ARM: mmp: register audio sram bank

 arch/arm/Kconfig                      |    1 +
 arch/arm/mach-mmp/Makefile            |    2 +-
 arch/arm/mach-mmp/brownstone.c        |    5 +
 arch/arm/mach-mmp/include/mach/mmp2.h |    7 ++
 arch/arm/mach-mmp/include/mach/sram.h |   35 +++++++
 arch/arm/mach-mmp/mmp2.c              |    1 +
 arch/arm/mach-mmp/sram.c              |  168 +++++++++++++++++++++++++++++++++
 7 files changed, 218 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-mmp/include/mach/sram.h
 create mode 100644 arch/arm/mach-mmp/sram.c

-- 
1.7.4.1

