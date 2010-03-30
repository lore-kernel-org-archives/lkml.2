Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab0C3NUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 09:20:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33093 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab0C3NUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 09:20:05 -0400
X-Authority-Analysis: v=1.1 cv=8Rq9yliVGc3GxcN10kx+g7e/eWPAtZnInWtRlahw0rA= c=1 sm=0 a=111p4j47RSwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=7d_E57ReAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=FsJUqAuNAAAA:8 a=Tty9oNO6AAAA:8 a=Z4Rwk6OoAAAA:8 a=meVymXHHAAAA:8 a=NoZIqgjevYOf4KZF8qoA:9 a=GKGdO8boADS-XwQJqkLNDnYypegA:4 a=PUjeQqilurYA:10 a=D6-X0JM3zdQA:10 a=LI9Vle30uBYA:10 a=7DSvI1NPTFQA:10 a=pzSI60jIEQsA:10 a=jbrJJM5MRmoA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] modules fix incorrect percpu usage
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, stable <stable@kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20100330033617.GE7683@Krystal>
References: <20100330033211.GC7683@Krystal>  <20100330033617.GE7683@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 30 Mar 2010 09:20:01 -0400
Message-ID: <1269955201.19685.5867.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 23:36 -0400, Mathieu Desnoyers wrote:
> * Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> > Should use per_cpu_ptr() to obfuscate the per cpu pointers (RELOC_HIDE is needed
> > for per cpu pointers).
> > 
> > Introduced by commit:
> > 
> > module.c: commit 6b588c18f8dacfa6d7957c33c5ff832096e752d3
> > 
> > This patch should be queued for the stable branch, for kernels 2.6.29.x to
> > 2.6.33.x.
> > (tested on 2.6.33.1 x86_64)
> 
> It's actually needed for mainline too (2.6.34-rc2).

Then all you need to do is submit it for mainline with a 
"Cc: stable@kernel.org" as you did below. It will then automatically be
added to the stable queue when Linus pulls it.

-- Steve

> 
> Thanks,
> 
> Mathieu
> 
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > CC: Randy Dunlap <randy.dunlap@oracle.com>
> > CC: Eric Dumazet <dada1@cosmosbay.com>
> > CC: Rusty Russell <rusty@rustcorp.com.au>
> > CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > CC: Tejun Heo <tj@kernel.org>
> > CC: Ingo Molnar <mingo@elte.hu>
> > CC: Andrew Morton <akpm@linux-foundation.org>
> > CC: Linus Torvalds <torvalds@linux-foundation.org>
> > CC: Greg Kroah-Hartman <gregkh@suse.de>
> > CC: Steven Rostedt <rostedt@goodmis.org>
> > CC: stable <stable@kernel.org>
> > ---
> >  kernel/module.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > 

