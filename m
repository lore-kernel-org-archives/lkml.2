Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452Ab2IKTIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 15:08:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39615 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab2IKTIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 15:08:35 -0400
Date: Tue, 11 Sep 2012 12:08:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: devel@driverdev.osuosl.org, Manohar Vanga <manohar.vanga@gmail.com>,
        linux-kernel@vger.kernel.org, Martyn Welch <martyn.welch@ge.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 1/2] staging/vme: Use pr_ printks in vme_user.c
Message-ID: <20120911190829.GA3327@kroah.com>
References: <20120904202053.GA23449@kroah.com>
 <1347347775-9282-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347347775-9282-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 04:16:14PM +0900, Toshiaki Yamane wrote:
> The below checkpatch warnings was fixed,
> 
> -WARNING: Prefer pr_info(... to printk(KERN_INFO, ...
> -WARNING: Prefer pr_warn(... to printk(KERN_WARNING, ...
> -WARNING: Prefer pr_err(... to printk(KERN_ERR, ...

A lot of these can be using dev_* instead of the pr_* functions, right?
Please convert to using them wherever possible.

Because of that, I can't take this patch, sorry.  Care to redo it?

thanks,

greg k-h
