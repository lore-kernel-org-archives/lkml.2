Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2JVTuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:50:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53422 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704Ab2JVTuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:50:23 -0400
Date: Mon, 22 Oct 2012 12:50:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/comedi: Use pr_ or dev_ printks in
 drivers/usbduxfast.c
Message-ID: <20121022195019.GA8567@kroah.com>
References: <1349871682-4543-1-git-send-email-yamanetoshi@gmail.com>
 <1350222097-7698-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350222097-7698-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 10:41:37PM +0900, YAMANE Toshiaki wrote:
> fixed below checkpatch warnings.
> - WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
> - WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> 
> and added pr_fmt.
> 
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>

Why did you send 2 copies of this?  Please resend the one you want me to
apply.

greg k-h
