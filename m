Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395Ab1BPCKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:10:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38469 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758342Ab1BPCKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 21:10:24 -0500
Date: Tue, 15 Feb 2011 18:09:44 -0800
From: Greg KH <gregkh@suse.de>
To: wei_wang@realsil.com.cn
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rts_pstor: fix sparse warning
Message-ID: <20110216020944.GA29648@suse.de>
References: <1297820618-11962-1-git-send-email-wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297820618-11962-1-git-send-email-wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 09:43:38AM +0800, wei_wang@realsil.com.cn wrote:
> From: wwang <wei_wang@realsil.com.cn>
> 
> Add static modifier before some function definitions; delete function
> named rtsx_transfer_sglist which won't be called.

Thanks for describing this better.

And now that we can easily see that you are doing more than one thing in
this patch, please redo it, only doing one-thing-per-patch as is the way
we require patches to be.

Care to resend this as a series of patches?

thanks,

greg k-h
