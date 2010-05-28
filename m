Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab0E1RVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 13:21:44 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:47843 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab0E1RVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 13:21:42 -0400
Date: Sat, 29 May 2010 03:21:35 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
       netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] net: mac8390 - Sort out memory/MMIO accesses and casts
 (was: Re: drivers/net/mac8390.c: Remove useless memcpy casting)
In-Reply-To: <AANLkTikexlmuunBQ-ydNaD8fkKcLmrsfJSEgvyMJdNqU@mail.gmail.com>
Message-ID: <alpine.OSX.2.00.1005290312230.691@localhost>
References: <l2k10f740e81004151234t3004275az36e7873493067a8a@mail.gmail.com>  <alpine.OSX.2.00.1004161206300.271@localhost> <AANLkTikexlmuunBQ-ydNaD8fkKcLmrsfJSEgvyMJdNqU@mail.gmail.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 23 May 2010, Geert Uytterhoeven wrote:

> >> But here's a better solution. I do not have the hardware to test it, 
> >> though. Finn, does it {look OK,work}?
> >
> > It looks fine. I can't test it right now, but I will do so when I get 
> > the opportunity.
> 
> Any news from the test front?

This is commit ba0f916ca7ac79356e2ed32a85c3aa8255b104e7, right?
If so, it tests OK here.

Finn

> 
> Gr{oetje,eeting}s,
> 
> 						Geert
