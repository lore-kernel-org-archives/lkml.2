Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934443Ab2JYCnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 22:43:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068Ab2JYCnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 22:43:19 -0400
Date: Wed, 24 Oct 2012 19:43:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging/comedi: Use pr_ or dev_ printks in
 drivers/gsc_hdpi.c
Message-ID: <20121025024357.GA24008@kroah.com>
References: <20121022195250.GD8567@kroah.com>
 <1351131793-6611-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351131793-6611-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 11:23:13AM +0900, YAMANE Toshiaki wrote:
> fixed below checkpatch warning.
> - WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...
> 
> some of them have been replaced by dev_dbg or pr_debug,
> and added pr_fmt.
> 
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>

This patch doesn't apply, can you redo it against the next linux-next
release and resend it?

thanks,

greg k-h
