Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab2G3VrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 17:47:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46261 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab2G3VrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 17:47:17 -0400
Date: Mon, 30 Jul 2012 14:47:13 -0700
From: "'Greg KH'" <gregkh@linuxfoundation.org>
To: Alexis Cortes <alexis.cortes@ti.com>
Cc: "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Quach, Brian'" <brian.quach@ti.com>,
        "'Llamas, Jorge'" <jorge.llamas@ti.com>
Subject: Re: [PATCH] usb: host: xhci: Compliance Mode port recovery
Message-ID: <20120730214713.GA12510@kroah.com>
References: <004101cd4f33$755e8eb0$601bac10$@cortes@ti.com>
 <20120621000734.GB32743@xanatos>
 <003701cd4fde$fd969290$f8c3b7b0$@cortes@ti.com>
 <20120622163214.GC629@xanatos>
 <20120622164704.GA6896@kroah.com>
 <4fe9f0c8.04c1b60a.11cc.3ca4SMTPIN_ADDED@mx.google.com>
 <20120626175121.GA2831@kroah.com>
 <4ffcad84.6710b60a.2b1a.0065SMTPIN_ADDED@mx.google.com>
 <20120711150604.GB22382@kroah.com>
 <5016ed18.0730b60a.1211.ffffe227SMTPIN_ADDED@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5016ed18.0730b60a.1211.ffffe227SMTPIN_ADDED@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 03:22:52PM -0500, Alexis Cortes wrote:
> Hi Greg,
> 
> I'm sorry for my late response on this. First of all thanks for your reply
> and your feedback :) 
> 
> We have been discussing with one of our major customers the possibility of
> identifying the platforms with the failing piece of hardware
> (SN65LVPE502CP), and as you suggested they have provided some DMI strings we
> can check in order to identify the platforms where those devices were
> installed. 
> 
> I have modified the patch so it will be executed only on those platforms
> reporting the specified DMI strings. I also applied some other suggestions
> you made on your previous email.
> 
> I would really appreciate if you could take a look at the patch and give me
> your feedback. Do you think that the patch is now suitable to be included in
> future kernel releases? 

That's really up to Sarah, as she is the maintainer of this driver.

How about resending it in a format that it can be applied in, and she
will take it from there?

But, at first glance, yes, it's much nicer now that you are matching on
DMI entries, thanks for taking the time to do that.

thanks,

greg k-h
