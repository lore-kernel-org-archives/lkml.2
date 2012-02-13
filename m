Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab2BMVoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 16:44:55 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53431 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753664Ab2BMVoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 16:44:54 -0500
X-Sasl-enc: I+fV3yWUlCeDM0dA6pgCe77O+RTbpa6uJ+9gYJw2knFq 1329169493
Date: Mon, 13 Feb 2012 13:44:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Sven-Haegar Koch <haegar@sdinet.de>
Cc: stable@vger.kernel.org,
        Linux-Kernel-Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32.55+ printk_ratelimit()
Message-ID: <20120213214431.GA11443@kroah.com>
References: <alpine.DEB.2.02.1202132148450.32459@aurora.sdinet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1202132148450.32459@aurora.sdinet.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 09:58:08PM +0100, Sven-Haegar Koch wrote:
> hello,
> 
> catching up with the stable kernel 2.6.32 I saw that 2.6.32.55 included 
> 8a64f33 "kernel.h: add printk_ratelimited and pr_<level>_rl"
> 
> Could it be that 2.6.32.x now also should get upstream 
> d8521fcc5e0ad3e79bbc4231bb20a6cdc2b50164 "printk_ratelimited(): fix 
> uninitialized spinlock" ?

Yes, I've now queued that one up, as well as another printk_ratelimit
fix that is needed.

thanks for letting me know.

greg k-h
