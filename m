Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab0KDOjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 10:39:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:57515 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab0KDOjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:39:07 -0400
Message-ID: <4CD2C551.2000604@kernel.org>
Date: Thu, 04 Nov 2010 15:38:09 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Marcus Meissner <meissner@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, fweisbec@gmail.com, mort@sgi.com,
        akpm@osdl.org, security@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
References: <20101104100914.GC25118@suse.de> <20101104114648.GA23381@elte.hu> <20101104122906.GH25118@suse.de> <20101104135802.GA31416@elte.hu> <20101104141104.GA31753@elte.hu> <20101104143322.GL25118@suse.de>
In-Reply-To: <20101104143322.GL25118@suse.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Nov 2010 14:38:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/04/2010 03:33 PM, Marcus Meissner wrote:
> I mean the kernel could hide it from uname, but lsb_release,
> /etc/redhat-release, /etc/SuSE-release etc still exist and then you
> can still use the fixed address list table inside your exploit. But an
> exploits needs to have such a list, making it harder to write.

I do believe that making things more difficult to exploit helps.  Many
people seem to think it only gives false sense of security tho.

> I also briefly thought about kernel ASLR, but my knowledge of the kernel
> loading is too limited whether this is even possible or at all useful.

We already have relocatable kernel for kdump and IIRC it doesn't add
runtime overhead, so putting the kernel at random address shouldn't be
too difficult.  Not sure how useful that would be tho.

Thanks.

-- 
tejun
