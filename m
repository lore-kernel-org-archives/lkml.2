Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab0CaBwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 21:52:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:46205 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756498Ab0CaBwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 21:52:21 -0400
Message-ID: <4BB2AA47.2030906@kernel.org>
Date: Wed, 31 Mar 2010 10:49:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>, stable <stable@kernel.org>
Subject: Re: [PATCH] modules fix incorrect percpu usage
References: <20100330135208.GC20673@Krystal>
In-Reply-To: <20100330135208.GC20673@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 31 Mar 2010 01:50:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2010 10:52 PM, Mathieu Desnoyers wrote:
> Should use per_cpu_ptr() to obfuscate the per cpu pointers (RELOC_HIDE is needed
> for per cpu pointers).
> 
> Introduced by commit:
> 
> module.c: commit 6b588c18f8dacfa6d7957c33c5ff832096e752d3
> 
> It applies to mainline as of 2.6.34-rc2. This patch should be queued for the
> stable branch, for kernels 2.6.29.x to 2.6.33.x.
> (based on 2.6.33.1, also applies to 2.6.34-rc2 -tip)
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Randy Dunlap <randy.dunlap@oracle.com>
> CC: Eric Dumazet <dada1@cosmosbay.com>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Tejun Heo <tj@kernel.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Greg Kroah-Hartman <gregkh@suse.de>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: stable <stable@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
