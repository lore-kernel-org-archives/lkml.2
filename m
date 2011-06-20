Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab1FTWgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:36:20 -0400
Received: from relais.videotron.ca ([24.201.245.36]:16049 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab1FTWgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:36:19 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 20 Jun 2011 18:36:18 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Alexander Holler <holler@ahsoftware.de>, linux-usb@vger.kernel.org,
        gregkh@suse.de, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the
 packed attribute
In-reply-to: <Pine.LNX.4.44L0.1106201640290.2113-100000@iolanthe.rowland.org>
Message-id: <alpine.LFD.2.00.1106201653450.2142@xanadu.home>
References: <Pine.LNX.4.44L0.1106201640290.2113-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Alan Stern wrote:

> On Mon, 20 Jun 2011, Nicolas Pitre wrote:
> 
> > > As far as I can tell, the other structures in ehci.h have 
> > > ((aligned(32)) simply in order to save space, since there can be large 
> > > numbers of these structures allocated.
> > 
> > How can increasing the alignment to 32 bytes save space?
> 
> No, no -- the alignment is _decreased_ to 32 bits.  Without the 
> attribute the alignment would have been 64 bits.

The aligned attribute requires a byte value not a bit value.
Maybe what you meant is ((aligned(4)) ?


Nicolas
