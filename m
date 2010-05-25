Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab0EYFZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 01:25:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32126 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab0EYFZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 01:25:06 -0400
Date: Mon, 24 May 2010 22:22:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: tglx <tglx@linutronix.de>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] timer.c: fix kernel-doc warning
Message-Id: <20100524222243.aa05d799.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090205.4BFB5F1A.00AC:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warning, add @timer description:
Warning(kernel/timer.c:335): No description found for parameter 'timer'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/timer.c |    1 +
 1 file changed, 1 insertion(+)

--- lnx-2634-g8-kerndoc.orig/kernel/timer.c
+++ lnx-2634-g8-kerndoc/kernel/timer.c
@@ -321,6 +321,7 @@ EXPORT_SYMBOL_GPL(round_jiffies_up_relat
 
 /**
  * set_timer_slack - set the allowed slack for a timer
+ * @timer: the timer to be modified
  * @slack_hz: the amount of time (in jiffies) allowed for rounding
  *
  * Set the amount of time, in jiffies, that a certain timer has
