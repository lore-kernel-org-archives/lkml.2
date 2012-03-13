Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426Ab2CMCvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 22:51:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2447 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715Ab2CMCvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 22:51:00 -0400
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=NFFUct9TueMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=dbjOAiOOIJ2w6XO2WtkA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331607058.25686.660.camel@gandalf.stny.rr.com>
Subject: [PATCH RT] preempt: Define preempt_check_resched_rt() for non
 PREEMPT config
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Clark Williams <clark@redhat.com>
Date: Mon, 12 Mar 2012 22:50:58 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compiler error when CONFIG_PREEMPT is not set.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 4125456..11412d7 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -95,6 +95,7 @@ do { \
 #define preempt_enable_no_resched()	do { } while (0)
 #define preempt_enable()		do { } while (0)
 #define preempt_check_resched()		do { } while (0)
+#define preempt_check_resched_rt()	do { } while (0)
 
 #define preempt_disable_notrace()		do { } while (0)
 #define preempt_enable_no_resched_notrace()	do { } while (0)


