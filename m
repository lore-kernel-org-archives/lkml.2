Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab0DUVS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:18:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:38880 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755301Ab0DUVS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:18:26 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19XKF1hSgNXoIeAUxnzi4RF76Ph22VvLCCl00H46n
	JCLKUNu52wtjAF
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 1/2] arch/avr32: Fix build failure caused by typo
Date: Wed, 21 Apr 2010 23:18:23 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004212318.23909.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This little patch fixes a build failure[1] caused by a typo.

Patch against linux-next20100421

References:
[1]http://kisskb.ellerman.id.au/kisskb/buildresult/2448162/

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 arch/avr32/kernel/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
index a047d69..668ed28 100644
--- a/arch/avr32/kernel/time.c
+++ b/arch/avr32/kernel/time.c
@@ -112,7 +112,7 @@ static struct clock_event_device comparator = {
 
 void read_persistent_clock(struct timespec *ts)
 {
-	ts->tv.sec = mktime(2007, 1, 1, 0, 0, 0);
+	ts->tv_sec = mktime(2007, 1, 1, 0, 0, 0);
 	ts->tv_nsec = 0;
 }
 
-- 
1.6.4.4

