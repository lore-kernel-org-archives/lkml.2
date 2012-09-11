Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857Ab2IKTIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 15:08:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52740 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759226Ab2IKTIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 15:08:52 -0400
Date: Tue, 11 Sep 2012 12:08:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: devel@driverdev.osuosl.org, Manohar Vanga <manohar.vanga@gmail.com>,
        linux-kernel@vger.kernel.org, Martyn Welch <martyn.welch@ge.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/2] staging/vme: Use dev_ printks in vme_user.c
Message-ID: <20120911190847.GB3327@kroah.com>
References: <1347347775-9282-1-git-send-email-yamanetoshi@gmail.com>
 <1347347823-9316-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347347823-9316-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 04:17:03PM +0900, Toshiaki Yamane wrote:
> The below checkpatch warnings was fixed,
> 
> -WARNING: Prefer pr_info(... to printk(KERN_INFO, ...
> -WARNING: Prefer pr_warn(... to printk(KERN_WARNING, ...
> -WARNING: Prefer pr_debug(... to printk(KERN_DEBUG, ...
> -WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
> 
> Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>

Same comment at 1/2 applies here as well.

greg k-h
