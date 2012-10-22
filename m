Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab2JVTpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:45:40 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39382 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798Ab2JVTpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:45:39 -0400
X-Sasl-enc: 4lCHMglvrPvVBp0w4u9bUmxtV0E00TCoP6Uwh/hjsK65 1350935138
Date: Mon, 22 Oct 2012 12:45:37 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/comedi: Use dev_ printks in drivers/vmk80xx.c
Message-ID: <20121022194537.GB30479@kroah.com>
References: <507BD53D.2070407@mev.co.uk>
 <1350298686-20770-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350298686-20770-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 07:58:06PM +0900, YAMANE Toshiaki wrote:
> -	printk(KERN_INFO "comedi#: vmk80xx: board #%d [%s] now attached\n",
> -	       dev->count, dev->board.name);
> +	dev_info(&intf->dev, "vmk80xx: board #%d [%s] now attached\n",
> +		 dev->count, dev->board.name);

The vmk80xx here is redundant, as it shows up from the dev_info()
printk.  Care to fix the two places here you did that and resend?

Note, when you resend please enumerate what version of the patch this
is, otherwise I can get very confused.

thanks,

greg k-h
