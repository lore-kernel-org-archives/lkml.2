Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0EWNW7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 09:22:59 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:58509 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab0EWNW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 09:22:57 -0400
Date: Sun, 23 May 2010 23:22:53 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
       netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] net: mac8390 - Sort out memory/MMIO accesses and casts
 (was: Re: drivers/net/mac8390.c: Remove useless memcpy casting)
In-Reply-To: <AANLkTikexlmuunBQ-ydNaD8fkKcLmrsfJSEgvyMJdNqU@mail.gmail.com>
Message-ID: <alpine.OSX.2.00.1005232317100.503@localhost>
References: <l2k10f740e81004151234t3004275az36e7873493067a8a@mail.gmail.com>  <alpine.OSX.2.00.1004161206300.271@localhost> <AANLkTikexlmuunBQ-ydNaD8fkKcLmrsfJSEgvyMJdNqU@mail.gmail.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 23 May 2010, Geert Uytterhoeven wrote:

> Any news from the test front?

Not as yet. I did get as far as building 2.6.34 for m68k. I have a couple 
of other small patches to test with this release too. I hope to send them 
within the merge window (i.e. this week).

Finn

> 
> Gr{oetje,eeting}s,
> 
> 						Geert
