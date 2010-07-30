Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab0G3Qzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 12:55:37 -0400
Received: from kroah.org ([198.145.64.141]:54999 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab0G3Qzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 12:55:35 -0400
Date: Fri, 30 Jul 2010 09:54:50 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: David Brownell <david-b@pacbell.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCHv5 2/3] USB: gadget: Use new composite features in some
 gadgets
Message-ID: <20100730165450.GA4943@kroah.com>
References: <231296.268.qm@web180308.mail.gq1.yahoo.com>
 <op.vgn0zfyq7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vgn0zfyq7p4s8u@pikus>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 06:48:41PM +0200, Michał Nazarewicz wrote:
> >>-static unsigned short gfs_vendor_id    = 0x0525;    /* XXX NetChip */
> >>-static unsigned short gfs_product_id   = 0xa4ac;    /* XXX */
> 
> >Look -- you can't assign NetChip numbers!!!
> 
> /me ashamed
> 
> Obviously, you're absolutely right.  I left the XXX mark to remember
> to clear the situation with the IDs but then completely forgot about
> it after g_multi got pulled. (It's especially bad since there is a
> conflict with hid.c).
> 
> So, to fix the situation, I need to ask Greg for the IDs?

Yes you do.  We shouldn't be using _any_ netchip ids anymore now that we
have our own vendor id assigned to us.

thanks,

greg k-h
