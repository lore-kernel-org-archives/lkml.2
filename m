Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab1FUO6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:58:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41472 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752160Ab1FUO6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:58:20 -0400
Date: Tue, 21 Jun 2011 10:58:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nicolas Pitre <nico@fluxnic.net>
cc: Alexander Holler <holler@ahsoftware.de>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing
 the packed attribute
In-Reply-To: <alpine.LFD.2.00.1106201824320.2142@xanadu.home>
Message-ID: <Pine.LNX.4.44L0.1106211054460.2327-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Nicolas Pitre wrote:

> > We don't fall into any of these cases, and therefore as you say, we
> > don't need packed.  Arnd and I have both explained this.  So why do you 
> > keep arguing that we do need it?
> 
> Please show me where I keep arguing that you need it?

Not explicitly perhaps.  But you did write:

> Doesn't mean that because it used to work that it is strictly correct.  
> Wouldn't be the first time that a GCC upgrade broke the kernel because 
> the kernel wasn't describing things properly enough.

which strongly implies that "packed" is needed.  You also wrote:

> Yes, but that's a consequence of not being able to access those fields 
> in their naturally aligned position anymore.  Hence the addition of the 
> align attribute to tell the compiler that we know that the structure is 
> still aligned to a certain degree letting the compiler to avoid 
> byte-oriented instructions when possible.

which is predicated on the assumption that "packed" is needed.

Alan Stern

