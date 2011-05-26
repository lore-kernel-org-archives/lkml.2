Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358Ab1EZT6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:58:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:28106 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990Ab1EZT6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:58:41 -0400
X-ExtLoop1: 1
Message-ID: <4DDEB0F0.3010101@linux.intel.com>
Date: Thu, 26 May 2011 12:58:40 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?B?TcOlbnMgUnVsbGfDpQ==?= =?UTF-8?B?cmQ=?= 
	<mans@mansr.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, sam@ravnborg.org
Subject: Re: [PATCH] ARM: Do not allow unaligned accesses when CONFIG_ALIGNMENT_TRAP
References: <20110523111648.10474.78396.stgit@e102109-lin.cambridge.arm.com>	 <20110523132124.GI17672@n2100.arm.linux.org.uk>	 <1306229953.19557.14.camel@e102109-lin.cambridge.arm.com>	 <yw1xipt0p4i9.fsf@unicorn.mansr.com>	 <BANLkTi=xLE9gP5YOdr9dR0DfsY1Ymzxu+w@mail.gmail.com>	 <20110524171331.GA2941@arm.com>	 <20110525111405.GA12010@e102109-lin.cambridge.arm.com>	 <20110525124348.GA2340@arm.com>	<yw1xaaeanbxe.fsf@unicorn.mansr.com>	 <BANLkTim2TOZgB-3Vkv5RcK572Qr07s3=CA@mail.gmail.com> <1306429854.26735.9.camel@e102144-lin.cambridge.arm.com>
In-Reply-To: <1306429854.26735.9.camel@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> So it sounds like we might not want to enable this blindly across all
> architectures. Indeed, on ARM, it encourages the compiler to pack
> variables on the stack which leads to the weird and wonderful alignment
> situation that has been encountered in this thread.

Interesting. I'm pretty sure it didn't do that when I added the flag.

Anyways making it a CONFIG is fine for me. Just don't set it on ARM. It 
should be set on x86
at least.

-Andi

