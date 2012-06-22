Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab2FVQrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:47:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37020 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab2FVQrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:47:08 -0400
Date: Fri, 22 Jun 2012 09:47:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alexis Cortes <alexis.cortes@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Quach, Brian'" <brian.quach@ti.com>,
        "'Llamas, Jorge'" <jorge.llamas@ti.com>
Subject: Re: [PATCH] usb: host: xhci: Compliance Mode port recovery
Message-ID: <20120622164704.GA6896@kroah.com>
References: <002801cd4e68$a4b4f3a0$ee1edae0$@cortes@ti.com>
 <20120619223928.GD21104@xanatos>
 <004101cd4f33$755e8eb0$601bac10$@cortes@ti.com>
 <20120621000734.GB32743@xanatos>
 <003701cd4fde$fd969290$f8c3b7b0$@cortes@ti.com>
 <20120622163214.GC629@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622163214.GC629@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 09:32:14AM -0700, Sarah Sharp wrote:
> This is really going to suck from a power management perspective.  "How
> do I stop the timer from polling?"  "Oh, you plug a device into every
> single port"  "But there's an internal port with nothing connected!"
> "Uhhh..."
> 
> Greg, are you sure wouldn't consider a sysfs file for changing the
> polling interval?

What I really want is a list of the PCI devices that this is affected
in, I'm sure that this can be found, as what else would Windows be
doing?

Alexis, what are you going to do about this for Windows?  Why not solve
it the same way here for Linux?

thanks,

greg k-h
