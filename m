Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab2GLEhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 00:37:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62998 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab2GLEhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 00:37:17 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-08-4ffe547bc3d3
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org
Cc: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>
Subject: [RESEND PATCH] extcon: spelling of detach in function doc
Date: Thu, 12 Jul 2012 13:37:01 +0900
Message-id: <1342067821-6481-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t9jQd3qkH/+Bj8+yVlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MFyvfMhdsZa94cWABSwPjVLYuRk4OCQETiefn57BC2GISF+6t
	B4pzcQgJTGeU2HztCZSzlEli//dpzCBVbAJaEvtf3ADrFhGQk3hy+w8zSBGzwE5GiZ0zVjGC
	JIQFnCSO37kOZrMIqEr8/3gUbAWvgIvEtO+/mCDWKUi0LjvEPoGRewEjwypG0dSC5ILipPRc
	I73ixNzi0rx0veT83E2MYC8+k97BuKrB4hCjAAejEg/vs8B//kKsiWXFlbmHGCU4mJVEeI2c
	gUK8KYmVValF+fFFpTmpxYcYpTlYlMR5Tby/+gsJpCeWpGanphakFsFkmTg4pRoY5/qd3rk3
	4dEm3s8pXw/eUOP1+RKZMON21oyPob/f9omJbLZl6vl9eBPn0YXLUvffN1xW1XSjaZdtunvI
	796oqDOcqp19hTsv6D33M/XIWLlQ18P96JuH9lqRq01/bvabv2XK38dhtfpaKSevGXM/5ti2
	PHHv3akfsyNeec7R/Mfqm3Pz7pVbdUosxRmJhlrMRcWJAHQNYRDeAQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Meerwald <pmeerw@pmeerw.net>

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 include/linux/extcon/extcon_gpio.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/extcon/extcon_gpio.h b/include/linux/extcon/extcon_gpio.h
index a2129b7..2d8307f 100644
--- a/include/linux/extcon/extcon_gpio.h
+++ b/include/linux/extcon/extcon_gpio.h
@@ -31,7 +31,7 @@
  * @irq_flags	IRQ Flags (e.g., IRQF_TRIGGER_LOW).
  * @state_on	print_state is overriden with state_on if attached. If Null,
  *		default method of extcon class is used.
- * @state_off	print_state is overriden with state_on if dettached. If Null,
+ * @state_off	print_state is overriden with state_on if detached. If Null,
  *		default method of extcon class is used.
  *
  * Note that in order for state_on or state_off to be valid, both state_on
-- 
1.7.0.4

