Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934520Ab1CYLM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:12:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:38553 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934407Ab1CYLM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:12:28 -0400
Message-Id: <20110325110939.701487744@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 11:12:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [patch 00/10] mfd: irq cleanup and namespace conversion
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series cleans up the interrupt code in drivers/mfd and
converts to the new function names in the core code.

If possible, push this to Linus for .39 so we can get rid of all the
deprecated and compat cruft in the core code.

Thanks,

	tglx

---
 88pm860x-core.c |   11 +++------
 ab3550-core.c   |   12 +++++-----
 ab8500-core.c   |   12 +++++-----
 asic3.c         |   38 +++++++++++++-------------------
 ezx-pcap.c      |   34 +++++++++++-----------------
 htc-egpio.c     |   23 ++++++++-----------
 htc-i2cpld.c    |   33 +++++++++-------------------
 jz4740-adc.c    |   16 ++++++-------
 max8925-core.c  |   10 +++-----
 max8998-irq.c   |    8 +++---
 max8998.c       |    4 +--
 stmpe.c         |   12 +++++-----
 t7l66xb.c       |   21 ++++++++---------
 tc3589x.c       |   12 +++++-----
 tc6393xb.c      |   21 ++++++++---------
 tps6586x.c      |    6 ++---
 twl4030-irq.c   |   66 +++++++++++++++-----------------------------------------
 twl6030-irq.c   |   25 ++++-----------------
 wm831x-irq.c    |    8 +++---
 wm8350-irq.c    |    8 +++---
 wm8994-irq.c    |    8 +++---
 21 files changed, 154 insertions(+), 234 deletions(-)

