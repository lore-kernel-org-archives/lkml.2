Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab2JWEVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 00:21:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65532 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab2JWEVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 00:21:33 -0400
Date: Mon, 22 Oct 2012 21:22:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <florian@openwrt.org>
Subject: Re: linux-next: build failure after merge of the final tree (usb
 tree related)
Message-ID: <20121023042202.GA23647@kroah.com>
References: <20121023151354.497d9b4f25b9ce7ff54e0785@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023151354.497d9b4f25b9ce7ff54e0785@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 03:13:54PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> In file included from drivers/usb/host/ohci-hcd.c:1165:0:
> drivers/usb/host/ohci-sm501.c: In function 'ohci_sm501_resume':
> drivers/usb/host/ohci-sm501.c:241:2: error: implicit declaration of function 'ohci_finish_controller_resume' [-Werror=implicit-function-declaration]
> 
> Caused by commit cfa49b4b88fe ("USB: ohci: merge
> ohci_finish_controller_resume with ohci_resume").

Ick.  Florian, can you send me a fix-up patch for this?

thanks,

greg k-h
