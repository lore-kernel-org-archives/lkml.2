Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab2IDUX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:23:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47242 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932679Ab2IDUX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:23:26 -0400
Date: Tue, 4 Sep 2012 13:20:53 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: devel@driverdev.osuosl.org, Manohar Vanga <manohar.vanga@gmail.com>,
        linux-kernel@vger.kernel.org, Martyn Welch <martyn.welch@ge.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/3] staging/vme: Use pr_ printks in vme_user.c
Message-ID: <20120904202053.GA23449@kroah.com>
References: <20120817074644.GL4559@mwanda>
 <1345547573-13371-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345547573-13371-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 08:12:53PM +0900, Toshiaki Yamane wrote:
> The below checkpatch warnings was fixed,
> 
> -WARNING: Prefer pr_info(... to printk(KERN_INFO, ...
> -WARNING: Prefer pr_debug(... to printk(KERN_DEBUG, ...
> -WARNING: Prefer pr_warn(... to printk(KERN_WARNING, ...
> -WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
> 
> and added pr_fmt.

A lot of these can be converted to use dev_info(), dev_debug(),
dev_warn(), and dev_err() instead.  Please do that whenever you have
access to a struct device.

So, sorry, I can't take this patch.

greg k-h
