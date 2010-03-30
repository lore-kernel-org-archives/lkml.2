Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0C3Tx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 15:53:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051Ab0C3Tx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 15:53:57 -0400
Date: Tue, 30 Mar 2010 12:53:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>, stable <stable@kernel.org>
Subject: Re: [PATCH] modules fix incorrect percpu usage
Message-Id: <20100330125304.53f079db.akpm@linux-foundation.org>
In-Reply-To: <20100330135208.GC20673@Krystal>
References: <20100330135208.GC20673@Krystal>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010 09:52:08 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

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

Why do you beleive this should be backported to -stable?  What are the
user-visible effects of this change?

