Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab2IDTcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 15:32:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51924 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757649Ab2IDTct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 15:32:49 -0400
X-Sasl-enc: sdA4l02kcWgp9rJ1+1GAvUg5wInolb7EnKZ4HtFeHO+J 1346787167
Date: Tue, 4 Sep 2012 12:30:18 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/rts_pstor: remove braces {} in sd.c
Message-ID: <20120904193018.GA4176@kroah.com>
References: <1346506980-2868-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346506980-2868-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2012 at 10:43:00PM +0900, Toshiaki Yamane wrote:
> fixed below checkpatch warnings.
> -WARNING: braces {} are not necessary for single statement blocks
> -WARNING: braces {} are not necessary for any arm of this statement
> 
> Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
> ---
>  drivers/staging/rts_pstor/sd.c | 1112 +++++++++++++++++-----------------------
>  1 file changed, 469 insertions(+), 643 deletions(-)

Why is the object file size changing with this patch applied?  That
implies that something went wrong with your patch, care to redo it in a
format that I can properly review it?

thanks,

greg k-h
