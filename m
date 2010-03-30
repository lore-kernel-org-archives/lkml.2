Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab0C3ChP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 22:37:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:47054 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788Ab0C3ChM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 22:37:12 -0400
Message-ID: <4BB16339.8090602@kernel.org>
Date: Tue, 30 Mar 2010 11:34:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, stable <stable@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Eric Dumazet <dada1@cosmosbay.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] [PATCH 2.6.29.x - 2.6.31.1] module: fix	__module_ref_addr()
References: <20100327143126.GA25615@Krystal> <1269890492.19685.4767.camel@gandalf.stny.rr.com> <20100329200946.GA1618@Krystal> <20100329210722.GA14993@kroah.com> <4BB15E1E.70504@kernel.org>
In-Reply-To: <4BB15E1E.70504@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 30 Mar 2010 02:34:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2010 11:12 AM, Tejun Heo wrote:
> Hello, Greg.
> 
> On 03/30/2010 06:07 AM, Greg KH wrote:
>>> Yes. 2.6.34-rc does not have this issue anymore, but the patch is needed in
>>> -stable.
>>
>> Why is this not in .34-rc2?  Can you find the specific patch in Linus's
>> tree that solves this and let stable@kernel.org know about it?
> 
> For 2.6.34, the following two patches should remove the problem.
> They're not in mainline yet but should appear in linux-next soon and
> after a few days, I'll push them to Linus.
> 
>  http://thread.gmane.org/gmane.linux.kernel/958794/focus=959493

Oh, Steven is right.  The ones which are removed by the above patch
are different ones.  That said, it might be a good idea to apply fixes
for them to -stable too.  Mathieu, are you interested in submitting
similar -stable fixes for kernel/module.c::percpu_modcopy() and
lockdep.c::static_obj()?

Thanks.

-- 
tejun
