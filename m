Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492Ab0D3Rny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:43:54 -0400
Received: from kroah.org ([198.145.64.141]:51963 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933265Ab0D3Rnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:43:33 -0400
Date: Fri, 30 Apr 2010 07:45:07 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Diego Giagio <diego@giagio.com>, Daniel Mack <daniel@caiaq.de>
Subject: Re: linux-next: build failure after merge of the staging-next tree
Message-ID: <20100430144507.GH1824@kroah.com>
References: <20100430155052.87507421.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100430155052.87507421.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 03:50:52PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the staging-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/net/usb/ipheth.c: In function 'ipheth_alloc_urbs':
> drivers/net/usb/ipheth.c:131: error: implicit declaration of function 'usb_buffer_alloc'
> drivers/net/usb/ipheth.c:134: warning: assignment makes pointer from integer without a cast
> drivers/net/usb/ipheth.c:141: warning: assignment makes pointer from integer without a cast
> drivers/net/usb/ipheth.c:153: error: implicit declaration of function 'usb_buffer_free'
> 
> Caused by commit 3cc96f50329227fbf34de2459491901b6ee1c98c ("USB: rename
> usb_buffer_alloc() and usb_buffer_free() users") from the usb tree
> interacting with commit a19259c3d589a014e5f47f148f74dfc44422c82b
> ("drivers/net/usb: Add new driver ipheth") which entered Linus' tree about
> April 25 via the net tree.
> 
> I applied the following fixup patch for today.

Thanks, I'll be sending in the patch that adds the api call to Linus
today so that the individual trees can make these changes.

thanks,

greg k-h
