Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab0HBWwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 18:52:43 -0400
Received: from kroah.org ([198.145.64.141]:55348 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409Ab0HBWwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 18:52:38 -0400
Date: Mon, 2 Aug 2010 15:52:21 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: David Brownell <david-b@pacbell.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "mina86@mina86.com" <mina86@mina86.com>
Subject: Re: [PATCHv5 2/3] USB: gadget: Use new composite features in some
 gadgets
Message-ID: <20100802225221.GA12051@kroah.com>
References: <231296.268.qm@web180308.mail.gq1.yahoo.com>
 <op.vgn0zfyq7p4s8u@pikus>
 <20100730165450.GA4943@kroah.com>
 <op.vgtl5umt7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vgtl5umt7p4s8u@pikus>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 07:14:08PM +0200, Michał Nazarewicz wrote:
> >On Fri, Jul 30, 2010 at 06:48:41PM +0200, Michał Nazarewicz wrote:
> >>So, to fix the situation, I need to ask Greg for the IDs?
> 
> On Fri, 30 Jul 2010 18:54:50 +0200, Greg KH <greg@kroah.com> wrote:
> >Yes you do.
> 
> Could I ask for two IDs then.  One for the Multifunction Composite
> Gadget (g_multi)

You now have device id 0104 reserved for this.

> and another for FunctionFS Gadget (g_ffs).

You now have device id 0105 reserved for this.

> Or is there some kind of procedure for that?

Heh, nope, you just have to ask and have code that needs it.

To keep everyone straight, here's the currently reserved device ids
managed by us:

1d6b  Linux Foundation
	0001  1.1 root hub
	0002  2.0 root hub
	0003  3.0 root hub
	0100  PTP Gadget
	0101  Audio Gadget
	0102  EEM Gadget
	0103  NCM (Ethernet) Gadget
	0104  Multifunction Composite Gadget
	0105  FunctionFS Gadget

thanks,

greg k-h
