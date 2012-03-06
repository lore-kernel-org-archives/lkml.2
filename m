Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab2CFFZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 00:25:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35940 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab2CFFZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 00:25:36 -0500
Message-ID: <4F559FB9.9040008@kernel.org>
Date: Mon, 05 Mar 2012 21:25:13 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mingo@kernel.org,
        tglx@linutronix.de, akpm@linux-foundation.org, hjl.tools@gmail.com
Subject: Re: [PATCH 02/30] x86-64: Use explicit sizes in sigcontext.h, prepare
 for x32
References: <1329696488-16970-1-git-send-email-hpa@zytor.com> <201202221222.58399.arnd@arndb.de> <4F453086.8030602@zytor.com> <201202222123.38816.arnd@arndb.de> <4F46F714.6010007@zytor.com>
In-Reply-To: <4F46F714.6010007@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 06:33 PM, H. Peter Anvin wrote:
> On 02/22/2012 01:23 PM, Arnd Bergmann wrote:
>>
>> I'd say we should fix at least the ones that are easy to spot because
>> they already use compat_u64 or have an #ifdef CONFIG_X86_64 in compat
>> code. I've looked at everything I could find that fits into that category
>> and found only two locations. My expectation is that all other data
>> structures that would fall into this category are already broken
>> for 32 bit emulation on x86.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>
> 
> Would you mind sending these as patches to the respective maintainers?
> Since they don't depend on the x32 patchset per se it's probably the
> best way to handle this.
> 
> Feel free to include my Acked-by: H. Peter Anvin <hpa@zytor.com>.
> 

Ping?

	-hpa

