Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab2EANqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 09:46:50 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56222 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753735Ab2EANqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 09:46:48 -0400
X-Sasl-enc: iDHgqKoOXJlChoIvNVipY808inp1p5JSk8blpzOulEmX 1335880007
Date: Tue, 1 May 2012 09:46:46 -0400
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the usb tree with the vfs tree
Message-ID: <20120501134646.GD31954@kroah.com>
References: <20120501150416.3b900d70af5f5173908aca00@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120501150416.3b900d70af5f5173908aca00@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 03:04:16PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/core/inode.c between commit eaf5fb5977e0 ("switch usbfs to
> use of simple_{unlink,rmdir}") from the  tree and commit fb28d58b72aa
> ("USB: remove CONFIG_USB_DEVICEFS") from the usb tree.
> 
> The latter removes the file modified by the former, so I just removed the
> file.

That sounds correct to me, thanks for doing this.

greg k-h
