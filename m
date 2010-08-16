Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0HPOuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:50:20 -0400
Received: from snt0-omc2-s16.snt0.hotmail.com ([65.55.90.91]:60476 "EHLO
	snt0-omc2-s16.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754262Ab0HPOuT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:50:19 -0400
Message-ID: <SNT135-w61C068A052AF30526B227CF39B0@phx.gbl>
X-Originating-IP: [209.87.232.162]
From: Jon E <je_nfd@hotmail.com>
To: <alan@lxorguk.ukuu.org.uk>
CC: <linux-kernel@vger.kernel.org>
Subject: RE: Problems with Recent Patches to IDE Driver
Date: Mon, 16 Aug 2010 10:50:19 -0400
Importance: Normal
In-Reply-To: <20100815212852.7c0e10ea@lxorguk.ukuu.org.uk>
References: <SNT135-w1108C18559F0BF8F0A3242F3980@phx.gbl>,<20100815212852.7c0e10ea@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 16 Aug 2010 14:50:18.0708 (UTC) FILETIME=[583B3940:01CB3D52]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----------------------------------------
> Date: Sun, 15 Aug 2010 21:28:52 +0100
> From: alan@lxorguk.ukuu.org.uk
> To: je_nfd@hotmail.com
> CC: linux-kernel@vger.kernel.org
> Subject: Re: Problems with Recent Patches to IDE Driver
>
> > I've googled for some answers but it seems there are no suggested workarounds for these problems. Perhaps someone reading this can offer some suggestions?
>
> Perhaps you could start by posting your patches ?
>
> Most distributions have pretty much dropped the old IDE driver for
> libata, which is actually better at supporting oddities so its probably
> best to go that way.

Could you elaborate a bit please?  Are you suggesting that the old driver was better at "supporting oddities" or that the new driver model is (better)?
 
I cannot post our code (not only because it's proprietary but it's also spread out amongst several files) but the snips I included in the original note illustrate the points of use.
 
The board is  an addon board with an ide interface, a RF-in port and an optional smartcard interface.  It starts out initializing itself as a network device (using the RF inteface) and then attempts to pick up the ide device information so it can continue the init process (set up ports, etc).
 
There's one thing I'm confused on, if I need to begin porting this to the new model.  Well, there's actually several things that confuse me, but I'll start with the basics.  Which base do I start with?  Looks to me (by reviewing the various *init routines in linux/drivers/ide, that I can choose: ide_pci, pci, platform, ioc4, ecard.  I think I can safely exclude ecard and ioc4, but that still leaves three from which to choose and I'm not how to determine how I need to proceed.
 
Jon 		 	   		  