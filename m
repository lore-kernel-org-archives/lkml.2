Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935421Ab0KQVht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 16:37:49 -0500
Received: from kroah.org ([198.145.64.141]:46560 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758951Ab0KQVhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 16:37:46 -0500
Date: Wed, 17 Nov 2010 13:25:55 -0800
From: Greg KH <greg@kroah.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-usb@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: g_fs: Fix compilation warning
Message-ID: <20101117212555.GB10541@kroah.com>
References: <20101117131427.fd26efd8.sfr@canb.auug.org.au>
 <20101116215906.GA2869@kroah.com>
 <0c1bd123752a7adc7f034ef81d155903da115081.1290007778.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c1bd123752a7adc7f034ef81d155903da115081.1290007778.git.mina86@mina86.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 05:09:47PM +0100, Michal Nazarewicz wrote:
> This commit fixes warning in f_fs.c introduced by "usb:
> gadget: f_fs: remove custom printk() wrappers":
> 
> In file included from drivers/usb/gadget/g_ffs.c:64:
> drivers/usb/gadget/f_fs.c:30:1: warning: "pr_fmt" redefined
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>

Now queued up, thanks.

greg k-h
