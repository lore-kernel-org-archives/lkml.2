Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab2BIPfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 10:35:44 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:59762
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752953Ab2BIPfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:35:43 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zz1432N98dK4015Lzz1202hzzz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZ4TZA-02-6Z3-02
X-M-MSG: 
Date: Thu, 9 Feb 2012 16:35:33 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: <linux-tip-commits@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>, <mingo@redhat.com>, <davej@redhat.com>,
        <Borislav.Petkov@amd.com>, <stable@kernel.org>, <tglx@linutronix.de>
Subject: Re: [tip:x86/urgent] x86/amd: Fix L1i and L2 cache sharing
 information for AMD family 15h processors
Message-ID: <20120209153533.GG30341@alberich.amd.com>
References: <20120208195229.GA17523@alberich.amd.com>
 <tip-32c3233885eb10ac9cb9410f2f8cd64b8df2b2a1@git.kernel.org>
 <20120209133754.GA12584@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120209133754.GA12584@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 02:37:54PM +0100, Ingo Molnar wrote:
> 
> This commit seems to cause a boot hang on an old Athlon64 CPU:

Are you sure that it's this commit, or is it possible that some other
patch in tip might trigger the trouble? (Systems boots fine with this
patch reverted?)

> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> numa_add_cpu cpu 0 node 0: mask now 0
> ExtINT not setup in hardware but reported by MP table
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
> ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> ...trying to set up timer (IRQ0) through the 8259A ...
> ..... (found apic 0 pin 0) ...
> ....... works.
> CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02

Can't reproduce this here (tried it on a couple of further
systems). Can you please provide dmesg or at least /proc/cpuinfo
output? (Also at the moment, it's not obvious to me how this timer
interrupt trouble is related to this patch.)


Thanks,

Andreas


