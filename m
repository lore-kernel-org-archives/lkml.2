Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751010Ab1FTAm5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 20:42:57 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59221 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab1FTAmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 20:42:55 -0400
Date: Sun, 19 Jun 2011 18:42:52 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Petr Tesarik <ptesarik@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of
	arbitrary physical addresses
Message-ID: <20110620004252.GE19693@parisc-linux.org>
References: <201106171038.25988.ptesarik@suse.cz> <20110617093032.GA19235@elte.hu> <4DFE7FF9.9070406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFE7FF9.9070406@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 09:02:17AM +1000, Ryan Mallon wrote:
> There are drivers where this makes sense. For example an FPGA device  
> with a proprietary register layout on the memory bus can be done this  
> way. The FPGA can simply be mapped in user-space via /dev/mem and  
> handled there. If the device requires no access other than memory bus  
> reads and writes then writing a custom char device driver just to get an  
> mmap function seems a bit overkill.

Calling a 30 line device driver "overkill" might in itself be overkill?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
