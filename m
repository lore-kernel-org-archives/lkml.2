Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab0DPCWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 22:22:42 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:36817 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab0DPCWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 22:22:40 -0400
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Apr 2010 22:22:40 EDT
Date: Fri, 16 Apr 2010 12:14:02 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
       netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] net: mac8390 - Sort out memory/MMIO accesses and casts
 (was: Re: drivers/net/mac8390.c: Remove useless memcpy casting)
In-Reply-To: <l2k10f740e81004151234t3004275az36e7873493067a8a@mail.gmail.com>
Message-ID: <alpine.OSX.2.00.1004161206300.271@localhost>
References: <l2k10f740e81004151234t3004275az36e7873493067a8a@mail.gmail.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 15 Apr 2010, Geert Uytterhoeven wrote:

> On Mon, Mar 8, 2010 at 18:16, Joe Perches <joe@perches.com> wrote:
>
> > Thanks, I'll submit a patch to fix it by tomorrow or so.
> 
> It hasn't been fixed yet.

Thanks for taking care of this, Geert.

> But here's a better solution. I do not have the hardware to test it, 
> though. Finn, does it {look OK,work}?

It looks fine. I can't test it right now, but I will do so when I get the 
opportunity.

Finn
