Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab0KRPpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:45:35 -0500
Received: from cantor.suse.de ([195.135.220.2]:51379 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab0KRPpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:45:34 -0500
Date: Thu, 18 Nov 2010 07:39:12 -0800
From: Greg KH <gregkh@suse.de>
To: Timur Tabi <timur@freescale.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101118153912.GA1443@suse.de>
References: <4CE44B1B.9040709@freescale.com>
 <20101117215147.GA26792@suse.de>
 <4CE452CD.3050001@freescale.com>
 <20101117221903.GA4066@suse.de>
 <4CE45A4E.70308@freescale.com>
 <20101118022434.GA9833@suse.de>
 <4CE546C5.8060401@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE546C5.8060401@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 09:31:17AM -0600, Timur Tabi wrote:
> Greg KH wrote:
> 
> > You need to create one as you really have a "bus" here, as you
> > described.
> 
> What about the fact that it's an Open Firmware driver?  My driver gets probed
> for each byte channel node in the device tree.
> 
> I'm still not sure why you think I have a bus.  I don't see where the UART
> drivers register a bus, and there's not a whole lot different between a byte
> channel and a UART.

But they are obviously two different things, right?

> > Please take a step back and go to your original message where you
> > described something like "we have a bus and devices we discover on the
> > bus and they have ids". 
> 
> I never said we have a bus.  There is no entity that conglomerates the byte
> channels.

Why not?  It sounds like there should be, right?  That would make things
much easier for you in the end from what I can tell.

thanks,

greg k-h
