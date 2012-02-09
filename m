Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab2BIBNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 20:13:43 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43729 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855Ab2BIBNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 20:13:40 -0500
Date: Wed, 8 Feb 2012 17:11:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] xvmalloc: total_pages can be ulong
Message-ID: <20120209011128.GA1926@kroah.com>
References: <CAB4K4y4UWXXb8Tm_arYG7=_MOyMxJnk3jRLGbaXTyFiNKM-TOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB4K4y4UWXXb8Tm_arYG7=_MOyMxJnk3jRLGbaXTyFiNKM-TOw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 11:20:51AM +0530, Ajeet Yadav wrote:
> >From 4763266cb0077d1082d4a1ef941448e9b4eb55ca Mon Sep 17 00:00:00 2001
> From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
> Date: Wed, 28 Dec 2011 11:08:34 +0530
> Subject: [PATCH] xvmalloc: total_pages can be ulong
> 
> total_pages is u64, its too large value considering
> that its in page unit on both 32-bit and 64-bit system
> , therefore make it ulong.

Your patch is line-wrapped and can not be applied.

Please use the git send-email command to send the patch, otherwise bad
things like this can happen :(

Care to redo it?

thanks,

greg k-h
