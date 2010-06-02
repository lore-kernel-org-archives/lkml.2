Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab0FBHEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 03:04:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350Ab0FBHEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 03:04:48 -0400
Date: Tue, 1 Jun 2010 23:59:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Tim Abbott <tabbott@ksplice.com>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module
 libcrc32c"
In-Reply-To: <201006021522.35784.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.1006012352150.8175@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <201006021239.42006.rusty@rustcorp.com.au> <alpine.LFD.2.00.1006012150070.8175@i5.linux-foundation.org> <201006021522.35784.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jun 2010, Rusty Russell wrote:
> 
> Hmm, you're still missing it.  Let me try again.
> 
> You weren't the best person to make the call.  That didn't occur to you, did
> it?

Sure, fair enough. 

At the same time, I'm the one who has to make the call. And quite often, 
that call is "this causes more problems than it fixes, we need to revert 
it".

Maybe I was too eager to revert this time. Quite often it ends up the 
other way, where we end up having broken kernels for too long because 
people weren't eager _enough_ to revert commits that had been bisected to 
be troublesome. It's hard to tell beforehand.

And quite often, subsystem maintainers are _way_ too eager to not revert 
the commits they wrote. So I really do end up having to balance that 
force. 

Does it always work out? Nope. 

			Linus
