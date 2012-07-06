Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680Ab2GFWxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 18:53:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41845 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab2GFWxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:53:51 -0400
Date: Fri, 6 Jul 2012 15:53:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: vmk80xx: All syntax issues fixed
Message-ID: <20120706225346.GA10471@kroah.com>
References: <1340933337-2752-1-git-send-email-sebastianbenvenuti@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340933337-2752-1-git-send-email-sebastianbenvenuti@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 10:28:57PM -0300, Sebastian Benvenuti wrote:
> @@ -1462,7 +1461,7 @@ static int __init vmk80xx_init(void)
>  {
>  	int retval;
>  
> -	printk(KERN_INFO "vmk80xx: version 0.8.01 "
> +	pr_info("vmk80xx: version 0.8.01 " \
>  	       "Manuel Gebele <forensixs@gmx.de>\n");

What's with the crazy '\' usage here?  That does nothing :(

greg k-h
