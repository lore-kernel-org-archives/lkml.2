Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab2IGPIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:08:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59390 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab2IGPIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:08:53 -0400
Message-ID: <504A0DF8.2030009@zytor.com>
Date: Fri, 07 Sep 2012 08:08:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ix86: improve determination of X86_MINIMUM_CPU_FAMILY
References: <5049B4C102000078000998FE@nat28.tlf.novell.com> <50499F3C.1070706@zytor.com> <5049BEF70200007800099965@nat28.tlf.novell.com>
In-Reply-To: <5049BEF70200007800099965@nat28.tlf.novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 12:31 AM, Jan Beulich wrote:
>
> Further, the "6" case is then completely pointless - X86_P6_NOP
> depends on X86_64. And with all features the kernel cares about
> that got added with Pentium and later being CPUID-enumerable,
> the "5" case would then be superfluous too.
>

The dependency X86_64 -> X86_P6_NOP is actually not inherent; it is a 
worksaround for a broken version of Microsoft HyperV presenting an 
inconsistent ISA to the guest.  We could allow enabling X86_P6_NOP on 32 
bits, in which family should be 6.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

