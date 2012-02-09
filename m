Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab2BINiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 08:38:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55919 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab2BINiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 08:38:12 -0500
Date: Thu, 9 Feb 2012 14:37:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, davej@redhat.com,
        Borislav.Petkov@amd.com, stable@kernel.org, tglx@linutronix.de
Subject: Re: [tip:x86/urgent] x86/amd: Fix L1i and L2 cache sharing
 information for AMD family 15h processors
Message-ID: <20120209133754.GA12584@elte.hu>
References: <20120208195229.GA17523@alberich.amd.com>
 <tip-32c3233885eb10ac9cb9410f2f8cd64b8df2b2a1@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-32c3233885eb10ac9cb9410f2f8cd64b8df2b2a1@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This commit seems to cause a boot hang on an old Athlon64 CPU:

CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
numa_add_cpu cpu 0 node 0: mask now 0
ExtINT not setup in hardware but reported by MP table
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...
..... (found apic 0 pin 0) ...
....... works.
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02

Thanks,

	Ingo
