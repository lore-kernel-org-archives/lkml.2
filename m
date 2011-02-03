Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab1BCNG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 08:06:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52551 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab1BCNG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 08:06:28 -0500
Message-ID: <4D4AA84F.3050200@monstr.eu>
Date: Thu, 03 Feb 2011 14:06:23 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, Tony Luck <tony.luck@intel.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [patch 3/8] microblaze: Remove stale irq_chip.end
References: <20110203003745.371989282@linutronix.de> <20110203004210.240154507@linutronix.de>
In-Reply-To: <20110203004210.240154507@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_chip.end got obsolete with the removal of __do_IRQ().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Michal Simek <monstr@monstr.eu>
---
  arch/microblaze/kernel/intc.c |   13 -------------
  1 file changed, 13 deletions(-)


Tested-by: Michal Simek <monstr@monstr.eu>

M

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
