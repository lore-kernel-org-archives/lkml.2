Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab0D1W2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 18:28:19 -0400
Received: from kroah.org ([198.145.64.141]:34839 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409Ab0D1W2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 18:28:17 -0400
Date: Wed, 28 Apr 2010 15:09:06 -0700
From: Greg KH <greg@kroah.com>
To: Roel Van Nyen <roel.vannyen@gmail.com>
Cc: gregkh@suse.de, hjanssen@microsoft.com, haiyangz@microsoft.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: hv: Fix coding style errors in NetVsc.c
Message-ID: <20100428220906.GA14160@kroah.com>
References: <1272491748-12516-1-git-send-email-roel.vannyen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272491748-12516-1-git-send-email-roel.vannyen@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 11:55:48PM +0200, Roel Van Nyen wrote:
> Fix coding style issues
> 
> Signed-of-by: Roel Van Nyen <roel.vannyen@gmail.com>
> ---
>  drivers/staging/hv/NetVsc.c |    4 ++--

This fix has already been made in the linux-next tree.  Can you make
sure you work off of it, and not an older tree in the future?

thanks,

greg k-h
