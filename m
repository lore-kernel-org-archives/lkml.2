Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab0ETHDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 03:03:46 -0400
Received: from vs81.sauer-cs.de ([80.244.252.81]:35972 "EHLO kbdbabel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469Ab0ETHDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 03:03:45 -0400
Date: Thu, 20 May 2010 11:03:23 +0400 (MSD)
From: Alexander Kurz <linux@blala.de>
X-X-Sender: linux@blala.de
To: Wolfram Sang <w.sang@pengutronix.de>
cc: Alexander Kurz <linux@blala.de>,
       Ken Kawasaki <ken_kawasaki@spring.nifty.jp>,
       "David S. Miller" <davem@davemloft.net>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial_cs: add and sort IDs for serial and modem cards
In-Reply-To: <20100519234933.GB14121@pengutronix.de>
Message-ID: <alpine.DEB.1.10.1005201050190.17478@blala.de>
References: <alpine.DEB.1.10.1005200034470.22205@blala.de> <20100519234933.GB14121@pengutronix.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 May 2010, Wolfram Sang wrote:

> On Thu, May 20, 2010 at 12:40:08AM +0400, Alexander Kurz wrote:
> > From a0b7bb602321ee0f28fefc955e103788190a7cfa Mon Sep 17 00:00:00 2001
> > From: Alexander Kurz <linux@kbdbabel.org>
> > Date: Mon, 17 May 2010 18:54:38 +0200
> > Subject: [PATCH] serial_cs: add and sort IDs for serial and modem cards
> > 
> > Signed-off-by: Alexander Kurz <linux@kbdbabel.org>
> 
> Cool, where did you get all these cards? :)

Hm, today used pcmcia cards are sometimes sold in a lot of 10-30 cards
for a few euros on the big e-flea-market. I bought some of them,
just to test if they all work.

