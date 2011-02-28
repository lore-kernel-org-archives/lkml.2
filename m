Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab1B1VTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 16:19:37 -0500
Received: from kroah.org ([198.145.64.141]:55167 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906Ab1B1VTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:19:35 -0500
Date: Mon, 28 Feb 2011 13:17:40 -0800
From: Greg KH <greg@kroah.com>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: Re: RFC: [PATCH 2/5] staging: sep: update existing sep headers
Message-ID: <20110228211740.GB8851@kroah.com>
References: <1298869869-4320-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298869869-4320-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 09:11:09PM -0800, Mark Allyn wrote:
> Updates include new structures and constants necessary
> for kernel crypto operation
> 
> Some functions in sep_main.c are made available to sep_crypto.c
> which will be added in subsequent patch
> 
> Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
> ---
>  drivers/staging/sep/sep_dev.h           |   24 ++++-
>  drivers/staging/sep/sep_driver_api.h    |  192 ++++++++++++++++++++++++++++++-
>  drivers/staging/sep/sep_driver_config.h |   14 +-
>  3 files changed, 215 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/staging/sep/sep_dev.h b/drivers/staging/sep/sep_dev.h
> index 0ffe68c..122dc94 100644
> --- a/drivers/staging/sep/sep_dev.h
> +++ b/drivers/staging/sep/sep_dev.h
> @@ -5,8 +5,8 @@
>   *
>   *  sep_dev.h - Security Processor Device Structures
>   *
> - *  Copyright(c) 2009,2010 Intel Corporation. All rights reserved.
> - *  Contributions(c) 2009,2010 Discretix. All rights reserved.
> + *  Copyright(c) 2009,2011 Intel Corporation. All rights reserved.
> + *  Contributions(c) 2009,2011 Discretix. All rights reserved.

So the contributions came from both companies?  Care to get a
signed-off-by from Discretix as well?

>   *
>   *  This program is free software; you can redistribute it and/or modify it
>   *  under the terms of the GNU General Public License as published by the Free
> @@ -28,6 +28,7 @@
>   *
>   *  CHANGES
>   *  2010.09.14  upgrade to Medfield
> + *  2011.02.22  enable kernel crypto

Changes do NOT belong in the individual files, that's what the git
changelog is for.

thanks,

greg k-h
