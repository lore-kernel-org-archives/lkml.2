Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab1F0Lto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 07:49:44 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:7043 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199Ab1F0Lr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 07:47:27 -0400
Date: Mon, 27 Jun 2011 13:47:05 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>, Gary Hade <garyhade@us.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Broke affinity for irq %i
Message-ID: <20110627134705.1bd95126@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Could someone familiar with function arch/x86/kernel/irq.c:fixup_irqs()
please add log levels to messages "Broke affinity for irq %i\n" and
"Cannot set affinity for irq %i\n"? As I put a few cores offline today
because of high temperature (not sure if it really helps, but that's a
different story) I got the following messages in my kernel log:

Broke affinity for irq 72
Broke affinity for irq 71
Broke affinity for irq 75
Broke affinity for irq 74

Due to the lack of log level for these messages, I have no idea if
there is something really wrong that I should report, or if this is a
mere informational message, or even a debug message which shouldn't be
printed at all by default. I would like this to be clarified.

Thanks,
-- 
Jean Delvare
