Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab0KDOtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 10:49:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:43360 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab0KDOtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:49:21 -0400
Message-ID: <4CD2C7AF.8020906@kernel.org>
Date: Thu, 04 Nov 2010 15:48:15 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Marcus Meissner <meissner@suse.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, jason.wessel@windriver.com,
        fweisbec@gmail.com, mort@sgi.com, akpm@osdl.org, security@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
References: <20101104100914.GC25118@suse.de> <20101104114648.GA23381@elte.hu> <20101104122906.GH25118@suse.de> <20101104135802.GA31416@elte.hu> <20101104141104.GA31753@elte.hu> <20101104143322.GL25118@suse.de> <4CD2C551.2000604@kernel.org> <4CD2C674.9000508@zytor.com>
In-Reply-To: <4CD2C674.9000508@zytor.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Nov 2010 14:48:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/04/2010 03:43 PM, H. Peter Anvin wrote:
>> We already have relocatable kernel for kdump and IIRC it doesn't add
>> runtime overhead, so putting the kernel at random address shouldn't be
>> too difficult.  Not sure how useful that would be tho.
> 
> It's very coarse-grained relocation, which is why it works.

Yeah, I recall reading the fairly simple relocator somewhere in the
x86 tree.  Would it be impossible/difficult to improve it?

> P.S. It's not just for kdump anymore.

Ah, didn't know that either.

Thanks.

-- 
tejun
