Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab1GRNVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 09:21:48 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:49178 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062Ab1GRNVr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 09:21:47 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jul 2011 09:21:47 EDT
From: Haojian Zhuang <hzhuang1@marvell.com>
To: Leo Yan <leoy@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
CC: Leo Yan <leoy@marvell.com>
Date: Mon, 18 Jul 2011 06:12:49 -0700
Subject: RE: [PATCH 0/2] Add audio sram support
Thread-Topic: [PATCH 0/2] Add audio sram support
Thread-Index: AcxFPAy0humtXCYcTMe0LHdHDBh6NwAEFhbs
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C05D3F4F2FA@SC-VEXCH1.marvell.com>
References: <1310987888-541-1-git-send-email-leoy@marvell.com>
In-Reply-To: <1310987888-541-1-git-send-email-leoy@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There would be a common sram driver in mainline.
________________________________________
From: Leo Yan [leoy@marvell.com]
Sent: Monday, July 18, 2011 7:18 PM
To: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Haojian Zhuang; nicolas.pitre@linaro.org; Russell King
Cc: Leo Yan
Subject: [PATCH 0/2] Add audio sram support

On mmp platform, there have 16KB sram buffer dedicated
to audio island. It can be to dynamically allocated for
versatile pcm devices. So implement the audio sram
allocator for managing it.

Leo Yan (2):
  ARM: mmp: register audio sram device
  ARM: mmp: add audio sram allocator

 arch/arm/Kconfig                            |    1 +
 arch/arm/mach-mmp/Makefile                  |    2 +-
 arch/arm/mach-mmp/audio_sram.c              |  118 +++++++++++++++++++++++++++
 arch/arm/mach-mmp/brownstone.c              |    1 +
 arch/arm/mach-mmp/include/mach/audio_sram.h |   31 +++++++
 arch/arm/mach-mmp/include/mach/mmp2.h       |    6 ++
 arch/arm/mach-mmp/mmp2.c                    |    1 +
 7 files changed, 159 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-mmp/audio_sram.c
 create mode 100644 arch/arm/mach-mmp/include/mach/audio_sram.h

--
1.7.4.1

