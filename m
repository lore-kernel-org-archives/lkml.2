Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879Ab2DJOep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 10:34:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51691 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754471Ab2DJOeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 10:34:44 -0400
X-Sasl-enc: 9tcWKGIBU32iEAifjdizN7n0w8LYhb9ykUQVZbodh9Pk 1334068483
Date: Tue, 10 Apr 2012 07:34:42 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] sep: Fix sign of error return
Message-ID: <20120410143442.GA14703@kroah.com>
References: <20120410132054.28262.82704.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410132054.28262.82704.stgit@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 02:21:24PM +0100, Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> One of our errors wasn't negative as intended. Fix this.
> (Found by Hillf Danton)
> 
> While we are at it turn user causable messages down to dev_dbg level in the
> ioctl paths.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Cc: stable@kernel.org
> ---
> 
>  drivers/staging/sep/sep_main.c |    6 +++---

Sorry for the delay, it's in my "to-apply" queue which I should get to
by the end of today, been digging out from the accumulated patch backlog
all yesterday and today.

greg k-h
