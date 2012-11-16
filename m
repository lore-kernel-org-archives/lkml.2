Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280Ab2KPCO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 21:14:26 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36682 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751048Ab2KPCOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 21:14:25 -0500
X-Sasl-enc: x1znGR7zThUy0cQJlEfAjUVjAld6YV2WaIFCCkhaAkGy 1353032064
Date: Thu, 15 Nov 2012 18:14:23 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <florian@openwrt.org>
Subject: Re: linux-next: manual merge of the usb tree with the usb.current
 tree
Message-ID: <20121116021423.GD492@kroah.com>
References: <20121114150746.433de520ffbc71b4281f3c62@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114150746.433de520ffbc71b4281f3c62@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 03:07:46PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got conflicts in
> drivers/usb/host/ehci-ls1x.c and drivers/usb/host/ohci-xls.c between
> commit e592c5d0b7db ("Revert "USB/host: Cleanup unneccessary irq disable
> code"") from the usb.current tree and commits ead92fae1290 ("USB: EHCI:
> remove Loongson 1B EHCI driver") and c2e91e046df6 ("USB: OHCI: remove
> Netlogic XLS OHCI platform driver") from the usb tree.
> 
> The latter removed the files, so I just did that and can carry the fix as
> necessary (no action is required).

Thanks, that sounds correct.

greg k-h
