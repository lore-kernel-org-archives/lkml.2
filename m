Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab2DTPw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:52:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54426 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab2DTPw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:52:57 -0400
Date: Fri, 20 Apr 2012 08:52:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, devel@driverdev.osuosl.org,
        max@stro.at, jbrenner@taosinc.com, grundler@chromium.org,
        linux-kernel@vger.kernel.org, bfreed@chromium.org,
        linux-iio@vger.kernel.org, jic23@cam.ac.uk
Subject: Re: [PATCH V4 1/2] staging: iio: light: convert multiple spaces to
 tab
Message-ID: <20120420155253.GC8327@kroah.com>
References: <1334906858-25578-1-git-send-email-ldewangan@nvidia.com>
 <1334906858-25578-2-git-send-email-ldewangan@nvidia.com>
 <4F9146D8.4060608@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9146D8.4060608@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 01:22:00PM +0200, Lars-Peter Clausen wrote:
> On 04/20/2012 09:27 AM, Laxman Dewangan wrote:
> > Using tab inplace of multiple spaces for indenting.
> > 
> > Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> > ---
> > Changes from V1:
> > As per Jonathan's feedback, creating this patch for only
> > indenting cleanups.
> > No change from V2
> > No Change from V3
> > 
> > This is already acked by Jonathan.
> 
> When resending a patch that has already been acked or reviewed, include the
> Acked-by or Reviewed-by line in the patch under your Signed-off-by.

I've now applied this patch, so it no longer needs to be resent.

thanks,

greg k-h
