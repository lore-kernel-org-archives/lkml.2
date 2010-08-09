Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab0HIVUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 17:20:32 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:58572 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598Ab0HIVUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 17:20:30 -0400
From: John Stultz <johnstul@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/2] Timekeeping Fixes
Date: Mon,  9 Aug 2010 14:20:08 -0700
Message-Id: <1281388810-25806-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	Chris and Jason provided some fixes that are needed for
the 2.6.36-rc tree. I'll backport the overflow issue for
2.6.35-stable once it is upstream.

thanks
-john

Cc: Thomas Gleixner <tglx@linutronix.de>


Chris Wilson (1):
  x86/hpet: Use the FSEC_PER_SEC constant for femto-second periods

Jason Wessel (1):
  timekeeping: Fix overflow in rawtime tv_nsec on 32 bit archs

 arch/x86/kernel/hpet.c    |    4 ++--
 include/linux/time.h      |    2 +-
 kernel/time/timekeeping.c |   11 +++++++----
 3 files changed, 10 insertions(+), 7 deletions(-)

