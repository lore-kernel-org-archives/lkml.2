Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab1DVWtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 18:49:39 -0400
Received: from kroah.org ([198.145.64.141]:59947 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab1DVWti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 18:49:38 -0400
Date: Fri, 22 Apr 2011 15:49:26 -0700
From: Greg KH <greg@kroah.com>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: Re: [PATCH 1/1] staging: sep: move to misc: sep: to move to mainline
Message-ID: <20110422224926.GB426@kroah.com>
References: <1303505449-25111-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303505449-25111-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 01:50:49PM -0700, Mark Allyn wrote:
> --- /dev/null
> +++ b/drivers/misc/sep/TODO
> @@ -0,0 +1,4 @@
> +Todo's so far (from Alan Cox)
> +- Check whether it can be plugged into any of the kernel crypto API
> +  interfaces - Crypto API 'glue' is still not ready to submit
> +- Clean up un-needed debug prints - Started to work on this

You copied over the TODO file?  Why, shouldn't those be resolved first?

Also, can you send a git patch that does the rename so we can verify
that nothing really did get changed?

I'll do a review of the code before accepting this as well, give me a
week or so.

thanks,

greg k-h
