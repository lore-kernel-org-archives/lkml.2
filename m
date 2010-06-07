Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab0FGDg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 23:36:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755309Ab0FGDgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 23:36:55 -0400
Date: Sun, 6 Jun 2010 20:31:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Tejun Heo <htejun@gmail.com>, Alex Deucher <alexdeucher@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: Re: Linux 2.6.35-rc2
In-Reply-To: <AANLkTimKd7uartwGVr1L1UN_FvC0TONmwXJlwXa4Ee7T@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006062026520.3515@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org> <AANLkTinpHAK3-qj26KSLLhMB5UUDT5I9aSkrxJeRRsSl@mail.gmail.com> <alpine.LFD.2.00.1006060710570.3515@i5.linux-foundation.org> <4C0BC35C.8070003@kernel.org> <4C0BC45A.6080104@gmail.com>
 <AANLkTinWB1M3uz5We566e2-UzwFsJuDi3rDAihgU5jCj@mail.gmail.com> <AANLkTimKd7uartwGVr1L1UN_FvC0TONmwXJlwXa4Ee7T@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Jun 2010, Alessandro Suardi wrote:

> On Sun, Jun 6, 2010 at 6:25 PM, Torsten Kaiser
>
> > [   82.510007] RAX: 0720072007200720

Ok, so that 0720072007200720 pattern is the VGA text-mode pattern for a 
sequence of spaces (07 is the default white-on-black attribute).

So it does seem to be some odd graphics/VGA-related thing that does 
something odd, and apparently overwrites random memory with bogus stuff..

> With -rc2 on F13, x86_64, Dell E6400 I had X not showing
>  on "startx" at the first attempt (totally blank screen), with
>  the oops pasted below found after Alt-Fn'ing into another
>  console tty and logging in.
>
> RBX: 0e200e200e200e20

Looks like the same thing - again spaces (but 0e is I think bright white 
on black or something).

			Linus
