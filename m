Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab0KDOpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 10:45:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60275 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab0KDOpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:45:43 -0400
Message-ID: <4CD2C674.9000508@zytor.com>
Date: Thu, 04 Nov 2010 10:43:00 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Marcus Meissner <meissner@suse.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, jason.wessel@windriver.com,
        fweisbec@gmail.com, mort@sgi.com, akpm@osdl.org, security@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
References: <20101104100914.GC25118@suse.de> <20101104114648.GA23381@elte.hu> <20101104122906.GH25118@suse.de> <20101104135802.GA31416@elte.hu> <20101104141104.GA31753@elte.hu> <20101104143322.GL25118@suse.de> <4CD2C551.2000604@kernel.org>
In-Reply-To: <4CD2C551.2000604@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2010 10:38 AM, Tejun Heo wrote:
> Hello,
>
> On 11/04/2010 03:33 PM, Marcus Meissner wrote:
>> I mean the kernel could hide it from uname, but lsb_release,
>> /etc/redhat-release, /etc/SuSE-release etc still exist and then you
>> can still use the fixed address list table inside your exploit. But an
>> exploits needs to have such a list, making it harder to write.
>
> I do believe that making things more difficult to exploit helps.  Many
> people seem to think it only gives false sense of security tho.
>
>> I also briefly thought about kernel ASLR, but my knowledge of the kernel
>> loading is too limited whether this is even possible or at all useful.
>
> We already have relocatable kernel for kdump and IIRC it doesn't add
> runtime overhead, so putting the kernel at random address shouldn't be
> too difficult.  Not sure how useful that would be tho.
>

It's very coarse-grained relocation, which is why it works.

	-hpa

P.S. It's not just for kdump anymore.
