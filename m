Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab0DZXmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 19:42:54 -0400
Received: from kroah.org ([198.145.64.141]:50924 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab0DZXmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 19:42:53 -0400
Date: Mon, 26 Apr 2010 16:42:50 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alex Manoussakis <alex@juniper.net>
Subject: Re: linux-next: build warning in Linus' tree
Message-ID: <20100426234250.GA20481@kroah.com>
References: <20100427093019.ae1b8c48.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100427093019.ae1b8c48.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 09:30:19AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> drivers/usb/serial/ti_usb_3410_5052.c: In function 'ti_download_firmware':
> drivers/usb/serial/ti_usb_3410_5052.c:1738: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'
> 
> Introduced by commit cdc04834ce70343aa6f87c5332ec66c35d968967 ("USB:
> ti_usb_3410_5052: adding multitech dialup fax/modem devices").

Thanks, Randy has already sent me a fix for this, I'm working on apply
it to my tree soon (doing must-fix things first...)

thanks,

greg k-h
