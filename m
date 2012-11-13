Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab2KMTrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:47:47 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54601 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab2KMTrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:47:45 -0500
Date: Tue, 13 Nov 2012 11:47:41 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, devel@driverdev.osuosl.org,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 1/1] staging: fwserial: Add TTY-over-Firewire serial
 driver
Message-ID: <20121113194741.GA30428@kroah.com>
References: <1350565015.23730.4.camel@thor>
 <cover.1351817601.git.peter@hurleysoftware.com>
 <55547e779e65e6865f18d537ef1a42191a4b7e46.1351817601.git.peter@hurleysoftware.com>
 <20121113003338.6aafd7c8@stein>
 <20121112235154.GA14017@kroah.com>
 <1352835444.16401.107.camel@thor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352835444.16401.107.camel@thor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 02:37:24PM -0500, Peter Hurley wrote:
> On Mon, 2012-11-12 at 15:51 -0800, Greg Kroah-Hartman wrote:
> > On Tue, Nov 13, 2012 at 12:33:38AM +0100, Stefan Richter wrote:
> > > On Nov 02 Peter Hurley wrote:
> > > > This patch provides the kernel driver for high-speed TTY
> > > > communication over the IEEE 1394 bus.
> > > > 
> > > > Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> > > 
> > > Hi Greg,
> > > 
> > > you asked for an Ack.  Here it is:  I am OK with this getting added to the
> > > staging tree.
> > 
> > Thanks, I'll queue it up later this week when I return from my travels.
> 
> Thanks, Greg.
> 
> Except for your and Alan's earlier concerns, which I think I addressed,
> I didn't get any other feedback on the TTY side of things. Are you
> personally reviewing this submission?

I will poke at it, odds are it will need some changes as there has been
some tty changes in the tty.git tree that might need to also be done
here.  Give me a bit of time to catch up...

thanks,

greg k-h
