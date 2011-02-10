Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab1BJSCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:02:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756745Ab1BJSCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:02:07 -0500
Date: Thu, 10 Feb 2011 10:01:45 -0800
From: Greg KH <gregkh@suse.de>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, david@woodhou.se,
        david.woodhouse@intel.com
Subject: Re: [RFC PATCH 02/13] Intel(R) MEI Driver
Message-ID: <20110210180145.GE13795@suse.de>
References: <849307$bgs43u@azsmga001.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <849307$bgs43u@azsmga001.ch.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 01:55:00AM -0800, Oren Weil wrote:
> diff --git a/drivers/char/Makefile b/drivers/char/Makefile

No description, or signed-off-by lines.  Have you read how to properly
create and submit a patch?  If so, why did you ignore those rules?

> index 5bc765d..e43ea27 100644
> --- a/drivers/char/Makefile
> +++ b/drivers/char/Makefile
> @@ -84,4 +84,5 @@ obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
>  obj-$(CONFIG_RAMOOPS)		+= ramoops.o
>  
>  obj-$(CONFIG_JS_RTC)		+= js-rtc.o
> +obj-$(CONFIG_INTEL_MEI)		+= mei/

You just broke the build.

I'm not going to review farther, it's a waste of my, and every one
else's time.

greg k-h
