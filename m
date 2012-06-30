Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab2F3WbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 18:31:22 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:41743 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752038Ab2F3WbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 18:31:21 -0400
Message-ID: <4FEF7E16.6080808@xenotime.net>
Date: Sat, 30 Jun 2012 15:30:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Richard Weinberger <richard@nod.at>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] linux/irq.h: fix kernel-doc warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix kernel-doc warning.  This struct member was removed in commit
id 875682648b89a3ebc06176d60dc280f810647839:
	irq: Remove irq_chip->release()
so remove its associated kernel-doc entry also.

Warning(include/linux/irq.h:338): Excess struct/union/enum/typedef member 'release' description in 'irq_chip'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Richard Weinberger <richard@nod.at>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |    2 --
 1 file changed, 2 deletions(-)

--- lnx-35-rc4.orig/include/linux/irq.h
+++ lnx-35-rc4/include/linux/irq.h
@@ -301,8 +301,6 @@ static inline irq_hw_number_t irqd_to_hw
  * @irq_pm_shutdown:	function called from core code on shutdown once per chip
  * @irq_print_chip:	optional to print special chip info in show_interrupts
  * @flags:		chip specific flags
- *
- * @release:		release function solely used by UML
  */
 struct irq_chip {
 	const char	*name;
