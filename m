Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab1FUUmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:42:06 -0400
Received: from relais.videotron.ca ([24.201.245.36]:53938 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab1FUUmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:42:01 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 21 Jun 2011 16:41:59 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alexander Holler <holler@ahsoftware.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        gregkh@suse.de, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the
 packed attribute
In-reply-to: <Pine.LNX.4.44L0.1106211054460.2327-100000@iolanthe.rowland.org>
Message-id: <alpine.LFD.2.00.1106211636190.2142@xanadu.home>
References: <Pine.LNX.4.44L0.1106211054460.2327-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jun 2011, Alan Stern wrote:

> On Mon, 20 Jun 2011, Nicolas Pitre wrote:
> 
> > > We don't fall into any of these cases, and therefore as you say, we
> > > don't need packed.  Arnd and I have both explained this.  So why do you 
> > > keep arguing that we do need it?
> > 
> > Please show me where I keep arguing that you need it?
> 
> Not explicitly perhaps.  But you did write:
> 
> > Doesn't mean that because it used to work that it is strictly correct.  
> > Wouldn't be the first time that a GCC upgrade broke the kernel because 
> > the kernel wasn't describing things properly enough.
> 
> which strongly implies that "packed" is needed.  You also wrote:

In this case ...

> > Yes, but that's a consequence of not being able to access those fields 
> > in their naturally aligned position anymore.  Hence the addition of the 
> > align attribute to tell the compiler that we know that the structure is 
> > still aligned to a certain degree letting the compiler to avoid 
> > byte-oriented instructions when possible.
> 
> which is predicated on the assumption that "packed" is needed.

... and also in this case, I was talking about proper use of the packed 
attribute in general, not at all about a specific case.  I wanted to 
provide a broader view to some people who expressed doubts and 
misunderstanding in the hope that the archive could keep this knowledge 
base available.

I apologize if that wasn't clear to you.


Nicolas
