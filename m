Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab0KKOCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:02:25 -0500
Received: from kroah.org ([198.145.64.141]:46458 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab0KKOCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:02:10 -0500
Date: Thu, 11 Nov 2010 05:59:57 -0800
From: Greg KH <greg@kroah.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv2 7/7] USB: gadget: FunctionFS: fix typos and coding
 styles
Message-ID: <20101111135957.GA21388@kroah.com>
References: <bfcc3341c937589451942f87d944659faf6c9e3c.1288256118.git.mina86@mina86.com>
 <8b3d49123e6d96ff584e0cb7e58aa978aa5a1b14.1288256118.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b3d49123e6d96ff584e0cb7e58aa978aa5a1b14.1288256118.git.mina86@mina86.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 05:31:24PM +0200, Michal Nazarewicz wrote:
> This commit changes FunctionFS as to make it more compliant
> with coding style as well as fixes several typos.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>  drivers/usb/gadget/f_fs.c  |  318 ++++++++++++++++++++++----------------------
>  drivers/usb/gadget/g_ffs.c |   39 +++---
>  2 files changed, 183 insertions(+), 174 deletions(-)

This patch no longer applies.  Care to rediff it and resend it against
the next linux-next tree?

thanks,

greg k-h
