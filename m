Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab0FDWxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 18:53:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530Ab0FDWxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 18:53:39 -0400
Date: Fri, 4 Jun 2010 15:48:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Brandon Philips <brandon@ifup.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module
 libcrc32c"
In-Reply-To: <201006041450.37611.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.1006041547140.8175@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <201006041032.04323.rusty@rustcorp.com.au> <alpine.LFD.2.00.1006031851301.8175@i5.linux-foundation.org> <201006041450.37611.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Jun 2010, Rusty Russell wrote:

> On Fri, 4 Jun 2010 11:25:00 am Linus Torvalds wrote:
> > But I suspect that is just myself trying to fool/argue my smarter half 
> > into taking it all.
> 
> Similar motivation for even asking.
> 
> They can stew in linux-next for another cycle: just found a trivial
> !SMP compile issue, and with all the other config options in there
> it could use some baking...

Yeah, considering the ia64 report, I can't lie to myself and say that the 
cleanups are going to be totally safe.

Can you send me a pointer to the safe/bugfix part, and I'll pull it for 
-rc2? I'd like to do that Saturday.

		Linus
