Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab2AWPSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:18:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58573 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab2AWPSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:18:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: Linux 3.3-1 out - merge window closed
Date: Mon, 23 Jan 2012 15:18:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc7; KDE/4.3.2; x86_64; ; )
Cc: "Ohad Ben-Cohen" <ohad@wizery.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Brian Swetland <swetland@google.com>
References: <CA+55aFwWEhobGDzkuRoXaS37y3tMU41ExhiR+vCa68cUNRehKg@mail.gmail.com> <CADMYwHxhyExw8jzAVT6PEdfXT-vCSLxg_eGbbqCwRNh0q3Q6eQ@mail.gmail.com> <20120123131808.GC23571@ponder.secretlab.ca>
In-Reply-To: <20120123131808.GC23571@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201231518.26158.arnd@arndb.de>
X-Provags-ID: V02:K0:rRkQ3UjGdwowZ41T64faw4v5f/uTJFZME7N1cz8c09i
 TkPmwj0NYxzYwxZ/dnw2ES52IV73yIlbj8k81UvD0T1enYwccp
 IDoAUAWzA57qgXV7BsocsDMI/oYWLJxgFFiP/ey0z4lqU/C69m
 v0eh+GZ1Wkk+UrXvUW9FbuhlNEl7IgtvsA4a982d5RhUNPFjh6
 gbdIuRzC5f9JGZY8JcK/cxOhze64ncYo7aX/5Mjs5VNf91hhZC
 xYm8k5FIETFeZ68nVnvdwaem0cAqn/AZE40wl7COTbW6hrqqf2
 pK6dAe1c8gkfAU3ejn3ejOIQwwn7qr0dJe9oDtsHBpu0cpo9El
 aFt1/4AuF8qUYnSb/JA8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 January 2012, Grant Likely wrote:
> On Mon, Jan 23, 2012 at 11:17:46AM +0200, Ohad Ben-Cohen wrote:
>
> > I realize there's a slim chance to get it merged at this point, but I
> > do think that both remoteproc and rpmsg are not so scary:
> > 
> > * The code is completely self contained, and the only few external
> > places it changes amount to grabbing a new virtio id (which is
> > Acked-by Rusty) and some OMAP init platform code (which is Acked-by
> > Tony). People who aren't explicitly using it won't notice it's there;
> > even its Kconfig entries get selected automatically when relevant
> > (i.e. only on OMAP4 at this point) and would never show up otherwise.
> 
> Hi Linus,
> 
> I'd also like to see this merged.  Rather than going off and inventing
> something completely new, Ohad has built on the existing virtio
> infrastructure to implement IPC between CPUs and DSPs running
> different operating environments.  This is a strong step in the
> RightDirection(tm) in my opinion and such behaviour should be
> encouraged.  :-)
> 

Agreed. I had reviewed earlier versions of this and they looked very
good.

	Arnd
