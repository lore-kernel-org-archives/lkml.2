Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab2EESxb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:53:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab2EESx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:53:29 -0400
Date: Sat, 5 May 2012 14:53:15 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix compile failure on PA-RISC
In-Reply-To: <20120505115851.1fecbe50@pyramind.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.1205051448400.2623@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1205042250130.18896@file.rdu.redhat.com>
 <20120505115851.1fecbe50@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 5 May 2012, Alan Cox wrote:

> On Fri, 4 May 2012 22:58:32 -0400 (EDT)
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Hi
> > 
> > This patch fixes compile failure on PA-RISC.
> > 
> > BTW. if the PA-RISC port is uncompilable for all 3.4-rc versions (and 
> > contains two other bugs that prevent it from booting) ... does it mean 
> > that I'm the only one who is using PA-RISC with recent kernel?
> 
> 
> Probably - and if so would you please get the NO_IRQ define fixed because
> it seems parisc also has no maintainer any more 8)
> 
> Alan

What NO_IRQ problem do you mean? There is
#define NO_IRQ          (-1)
in arch/parisc/include/asm/irq.h.

And there are other NO_IRQ definitions in other architectures, some 
defining it to ((unsigned int)(-1)), some to 0xffffffff, some to INT_MAX, 
some to (-1) and some to (0).

Some drivers define NO_IRQ too, if not defined by the architecture.

Mikulas
