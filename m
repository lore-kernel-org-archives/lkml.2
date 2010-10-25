Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab0JYUEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 16:04:55 -0400
Received: from pqueueb.post.tele.dk ([193.162.153.10]:56245 "EHLO
	pqueueb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757577Ab0JYUEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 16:04:53 -0400
X-Greylist: delayed 1353 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Oct 2010 16:04:53 EDT
Date: Mon, 25 Oct 2010 21:41:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: namhyung@gmail.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sparc32: fix build failure on CONFIG_SPARC_LEON
Message-ID: <20101025194155.GA26282@merkur.ravnborg.org>
References: <1288021958-3130-3-git-send-email-namhyung@gmail.com> <20101025.090043.71110898.davem@davemloft.net> <20101025161122.GA25358@merkur.ravnborg.org> <20101025.115331.193708760.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101025.115331.193708760.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 11:53:31AM -0700, David Miller wrote:
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Mon, 25 Oct 2010 18:11:22 +0200
> 
> > On Mon, Oct 25, 2010 at 09:00:43AM -0700, David Miller wrote:
> >> From: Namhyung Kim <namhyung@gmail.com>
> >> Date: Tue, 26 Oct 2010 00:52:38 +0900
> >> 
> >> >   CC      arch/sparc/kernel/irq_32.o
> >> > arch/sparc/kernel/irq_32.c: In function 'request_fast_irq':
> >> > arch/sparc/kernel/irq_32.c:370:25: error: conflicting types for 'trapbase_cpu1'
> >> 
> >> I doubt SMP LEON chips even exist, so better to just anti-dep
> >> this in arch/sparc/Kconfig
> > 
> > I have a nice eval board at my desk with a dual-core LEON4 processor.
> > I only lack time to play with it...
> 
> Ok.  But whenever someone gets a time to play with it and
> verify it works, we can sort out this build failure by
> modifying the code as needed.
> 
> But for now I prefer the Kconfig SMP dependency fix.

Yup - I agree.
My only intention was to tell that such a processor exists in reality
and not only on paper.

	Sam
