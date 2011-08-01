Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1HAC45 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 22:56:57 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:50613 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab1HAC4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 22:56:50 -0400
X-ASG-Debug-ID: 1312167409-082efa450001-xx1T2L
X-Barracuda-Envelope-From: leoy@marvell.com
From: Leo Yan <leoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        haojian.zhuang@marvell.com, nicolas.pitre@linaro.org,
        linux@arm.linux.org.uk, plagnioj@jcrosoft.com
Cc: Leo Yan <leoy@marvell.com>
X-ASG-Orig-Subj: [PATCH V2 0/2] ARM: mmp: add audio sram support
Subject: [PATCH V2 0/2] ARM: mmp: add audio sram support
Date: Mon,  1 Aug 2011 10:59:05 +0800
X-ASG-Orig-Subj: [PATCH V2 0/2] ARM: mmp: add audio sram support
Message-Id: <1312167547-26740-1-git-send-email-leoy@marvell.com>
X-Mailer: git-send-email 1.7.4.1
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1312167409
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On mmp platform, there have sram buffer dedicated
to audio island. It can be to dynamically allocated
for versatile pcm devices. So add the audio sram
allocator for managing it.

Leo Yan (2):
  ARM: mmp: register audio sram device
  ARM: mmp: add audio sram allocator

 arch/arm/Kconfig                            |    1 +
 arch/arm/mach-mmp/Makefile                  |    2 +-
 arch/arm/mach-mmp/audio_sram.c              |   99 +++++++++++++++++++++++++++
 arch/arm/mach-mmp/brownstone.c              |    1 +
 arch/arm/mach-mmp/include/mach/audio_sram.h |   24 +++++++
 arch/arm/mach-mmp/include/mach/mmp2.h       |    6 ++
 arch/arm/mach-mmp/mmp2.c                    |    1 +
 7 files changed, 133 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-mmp/audio_sram.c
 create mode 100644 arch/arm/mach-mmp/include/mach/audio_sram.h

-- 
1.7.4.1

