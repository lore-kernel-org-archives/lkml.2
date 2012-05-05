Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab2EESzU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:55:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab2EESzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:55:18 -0400
Date: Sat, 5 May 2012 14:55:08 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix compile failure on PA-RISC
In-Reply-To: <1798237.g4OIBKAx4s@donald.sf-tec.de>
Message-ID: <Pine.LNX.4.64.1205051445360.2623@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1205042250130.18896@file.rdu.redhat.com>
 <1798237.g4OIBKAx4s@donald.sf-tec.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 May 2012, Rolf Eike Beer wrote:

> Mikulas Patocka wrote:
> > Hi
> > 
> > This patch fixes compile failure on PA-RISC.
> > 
> > BTW. if the PA-RISC port is uncompilable for all 3.4-rc versions (and
> > contains two other bugs that prevent it from booting) ... does it mean
> > that I'm the only one who is using PA-RISC with recent kernel?
> > 
> > Mikulas
> > 
> > ---
> > 
> > Fix compile failure on PA-RISC
> > 
> > This patch fixes compile error on PA-RISC.
> > 
> > The problem is this:
> > linux/bitops.h includes asm/bitops.h. Through a chain of dependencies
> > asm/bitops.h includes asm/page.h and asm/page.h needs function fls and
> > others defined in asm/bitops.h and linux/bitops.h --- and these
> > functions are not yet defined because the files linux/bitops.h and
> > asm/bitops.h hasn't been fully processed.
> 
> I've posted a set of patches on 2012-04-21 both on linux-kernel and linux-
> parisc, but apart from one ACK I got no reaction.
> 
> I did only move the definition of PAGE0 from asm/pdc.h to asm/page.h and fixed 
> another bunch of breakage that was detected while fixing this.
> 
> Eike

I acknowledge that your patches work. So send them directly to Linus. I 
think there is not much maintenance being done on PA-RISC.

Mikulas
