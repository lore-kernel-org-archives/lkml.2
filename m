Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab0KTBm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 20:42:26 -0500
Received: from kroah.org ([198.145.64.141]:34193 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab0KTBmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 20:42:16 -0500
Date: Fri, 19 Nov 2010 17:20:01 -0800
From: Greg KH <greg@kroah.com>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] sep: Introduce sep driver
Message-ID: <20101120012001.GA10624@kroah.com>
References: <1290037536-12660-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290037536-12660-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 03:45:36PM -0800, Mark Allyn wrote:
> This driver is for the Security Processor, a dedicated encryption
> and decryption driver that is used on the Intel mobile platform.
> 
> This has been checked with checkpatch and there are four
> warnings for lines over 80 charactors.
> 
> There is one compile warning. This is for a function that is
> only used if the rar register driver is needed. There is an
> ifdef in a header file that stubs out the rar register driver
> if the rar register is not configured.
> 
> This patch is referenced off of next-20101117.
> 

Minor comment:

> --- /dev/null
> +++ b/drivers/staging/sep/TODO
> @@ -0,0 +1,12 @@
> +Todo's so far (from Alan Cox)
> +- Fix firmware loading - Done 09/10 M. Allyn
> +- Get firmware into firmware git tree - Firmware is non open source
> +- Review and tidy each algorithm function - Done 09/10 M. Allyn
> +- Check whether it can be plugged into any of the kernel crypto API
> +  interfaces - Crypto API 'glue' is still not ready to submit
> +- Do something about the magic shared memory interface and replace it
> +  with something saner (in Linux terms) - Done 09/10 M. Allyn
> +- Clean up unused ioctls - Needs vendor help
> +- Clean up unused fields in ioctl structures - Needs vendor help
> +- 64 bit size to be used for all user space addresses passed
> +  to ioctl - Done 10/10 M. Allyn

Remove entries in the TODO file that you have finished, only list what
needs to be done.

Also, please put your email address in the file for who to send patches
to for this driver, like the other TODO files in the
drivers/staging/*/TODO files have.

Care to send a follow-on patch for these minor changes?

thanks,

greg k-h
