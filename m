Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab0HYVu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 17:50:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43100 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab0HYVuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 17:50:25 -0400
Message-ID: <4C758FE5.8050905@kernel.org>
Date: Wed, 25 Aug 2010 14:49:25 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Stable Maintainers <stable@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [Patch] numa:x86_64: Cacheline aliasing makes for_each_populated_zone
 extremely expensive -V2.
References: <20100818183024.GZ3043@sgi.com> <4C6DB62C.9040105@zytor.com> <20100820135822.GA3220@sgi.com> <20100820150319.GB3220@sgi.com> <4C6EAA48.7070902@zytor.com> <20100821130757.GC3220@sgi.com> <4C72EB41.9000002@zytor.com> <20100825110815.GD3220@sgi.com> <4C756768.2060903@zytor.com>
In-Reply-To: <4C756768.2060903@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2010 11:56 AM, H. Peter Anvin wrote:
> On 08/25/2010 04:08 AM, Robin Holt wrote:
>>> So yes, this means adding an interface to the e820 allocator, even
>>> though it's scheduled to be replaced.  Because the new implementation
>>> will see the new interface and know they have to implement it, and the
>>> interface will make it clear just what exactly is expected of the
>>> implementation.
>>
>> What is the new allocator called?  Who is developing it?  When do you
>> expect it to be introduced into the kernel?
>>
> 
> memblock -- the core is already in the kernel and used by several
> non-x86 architectures, and so we want to switch x86 to use it, as well.
> 
> Ben Herrenschmidt and Yinghai Lu are driving this one.
> 
> As with anything in Linux it will get integrated when it is ready.  It
> would be nice if it was ready for .37, but it's not certain.

i put latest version against current tip/master in

git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git memblock

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-2.6-yinghai.git;a=shortlog;h=refs/heads/memblock

Thanks

Yinghai
