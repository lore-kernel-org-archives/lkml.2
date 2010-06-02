Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab0FBJHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:07:51 -0400
Received: from ozlabs.org ([203.10.76.45]:38003 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819Ab0FBJHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:07:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module libcrc32c"
Date: Wed, 2 Jun 2010 18:37:29 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Brandon Philips <brandon@ifup.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <alpine.LFD.2.00.1006020022000.8175@i5.linux-foundation.org> <alpine.LFD.2.00.1006020102520.8175@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006020102520.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006021837.31016.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 05:42:32 pm Linus Torvalds wrote:
> 
> On Wed, 2 Jun 2010, Linus Torvalds wrote:
> > 
> > IOW, things like this.. Pure code movement to peel off some stuff.
> 
> Here's a second one. It's slightly less trivial - since we now have error 
> cases - and equally untested so it may well be totally broken. But it also 
> cleans up a bit more, and avoids one of the goto targets, because the 
> "move_module()" helper now does both allocations or none.
> 
> But now I'm bored and tired, so I think this will be all for tonight. The 
> load_module function has gone from ~490 lines to ~370 lines, but that's 
> still so many that I don't honestly think this makes any readability 
> improvement yet.

Both applied and I'll play a little more later...

Thanks!
Rusty.
