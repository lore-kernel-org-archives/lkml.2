Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965723Ab2ERRNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:13:19 -0400
Received: from www.tglx.de ([62.245.132.106]:59998 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965650Ab2ERRNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:13:13 -0400
Message-Id: <20120518163020.548627576@glx-um.de>
User-Agent: quilt/0.48-1
Date: Fri, 18 May 2012 16:45:43 -0000
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 00/24] timers: Cleanup Kconfig
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series moves the timer related Kconfig switches
which are copied all over arch/ to kernel/time/Kconfig and 
lets arch Kconfigs select the core options.

     Anna-Maria
---
 arch/alpha/Kconfig      |    4 +---
 arch/arm/Kconfig        |   18 ++----------------
 arch/avr32/Kconfig      |    4 +---
 arch/blackfin/Kconfig   |    8 +++-----
 arch/c6x/Kconfig        |    7 +------
 arch/cris/Kconfig       |    7 +------
 arch/hexagon/Kconfig    |   15 +++------------
 arch/ia64/Kconfig       |    9 ++-------
 arch/m32r/Kconfig       |    4 +---
 arch/m68k/Kconfig       |    7 +------
 arch/microblaze/Kconfig |    7 +------
 arch/mips/Kconfig       |   13 ++-----------
 arch/mn10300/Kconfig    |    7 +------
 arch/openrisc/Kconfig   |    4 +---
 arch/powerpc/Kconfig    |   12 +++---------
 arch/s390/Kconfig       |   12 +++---------
 arch/score/Kconfig      |    4 +---
 arch/sh/Kconfig         |   12 ++----------
 arch/sparc/Kconfig      |   15 +++------------
 arch/tile/Kconfig       |    4 +---
 arch/um/Kconfig.common  |    5 +----
 arch/unicore32/Kconfig  |    3 ---
 arch/x86/Kconfig        |   31 +++++++------------------------
 kernel/time/Kconfig     |   31 +++++++++++++++++++++++++++++++
 24 files changed, 73 insertions(+), 170 deletions(-)



