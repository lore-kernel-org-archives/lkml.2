Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab0CTPh1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 11:37:27 -0400
Received: from relais.videotron.ca ([24.201.245.36]:33159 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab0CTPhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 11:37:25 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sat, 20 Mar 2010 11:37:24 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Paulius Zaleckas <paulius.zaleckas@gmail.com>, rth@twiddle.net,
       lkml <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
       u.kleine-koenig@pengutronix.de, simon.kagstrom@netinsight.net,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] MTD: Fix Orion NAND driver compilation with ARM OABI
In-reply-to: <19364.58488.817538.692599@pilspetsen.it.uu.se>
Message-id: <alpine.LFD.2.00.1003201132500.31128@xanadu.home>
References: <20100320085507.4038.96426.stgit@pauliusz>
 <1269078083.4028.5586.camel@macbook.infradead.org>
 <badfd5ba1003200420xc0680c1h8b4cccd02a8fdaba@mail.gmail.com>
 <1269086286.4028.6039.camel@macbook.infradead.org>
 <19364.58488.817538.692599@pilspetsen.it.uu.se>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Mar 2010, Mikael Pettersson wrote:

> I missed the start of this thread, but looking at orion_nand.c I fail to
> see why you'd need to mess with inline asm for reading a sequence of u64
> values from an I/O location to an array.

The reason for doing so with inline asm in the first place was not 
discussed in this thread.

> Rewriting that to proper C generates a nice ldrd;strd loop with my gcc-4.4.3.

Sure, GCC version 4.4.3 does the right thing.  Not all of them do.


Nicolas
