Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214Ab0DHAbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 20:31:33 -0400
Received: from kroah.org ([198.145.64.141]:60477 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758103Ab0DHAbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 20:31:12 -0400
Date: Wed, 7 Apr 2010 17:30:58 -0700
From: Greg KH <greg@kroah.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, Peter Korsgaard <jacmet@sunsite.dk>,
       Rupesh Gujare <rupeshgujare@gmail.com>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 8/8] USB: testusb: testusb compatibility with
 FunctionFS gadget
Message-ID: <20100408003058.GD4365@kroah.com>
References: <cover.1270644740.git.mina86@mina86.com>
 <033ad254a3bba337e7a37cc6071b7debc7051801.1270644740.git.mina86@mina86.com>
 <b866157fc128769a3cdf9ae76f9fc21743776778.1270644740.git.mina86@mina86.com>
 <d8e956ce78914750460877b87ba2b0f707ab8a0f.1270644740.git.mina86@mina86.com>
 <a5ed8238af68738effaf1610f4653d98b9435098.1270644740.git.mina86@mina86.com>
 <922265f162fd3b45408c234d0d17e924b6f61671.1270644740.git.mina86@mina86.com>
 <15d6fb76583235c380569d11d904cc0e8d019067.1270644740.git.mina86@mina86.com>
 <3c4f11cdfb08952e964879c343d6ed7ceedc9542.1270644740.git.mina86@mina86.com>
 <a333dd3a5ec0ce230038c0ec3f2457d22349f2c8.1270644740.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a333dd3a5ec0ce230038c0ec3f2457d22349f2c8.1270644740.git.mina86@mina86.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 03:41:35PM +0200, Michal Nazarewicz wrote:
> The FunctionFS gadget may provide the source/sink interface
> not as the first interface (with id == 0) but some different
> interface hence a code to find the interface number is
> required.
> 
> (Note that you will still configure the gadget to report
> idProduct == 0xa4a4 (an "echo 0xa4a4
> >/sys/module/g_ffs/parameters/usb_product" should suffice) or
> configure host to handle 0x0525:0xa4ac devices using the
> usbtest driver.)
> 
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>

Ah, kernel code with a userspace test program.  If only all patches came
with stuff like this.

Very nice job, I like it a lot.  Care to take the minor comments so far,
and redo it?  I'll be glad to take the patches into my tree then.

thanks,

greg k-h
