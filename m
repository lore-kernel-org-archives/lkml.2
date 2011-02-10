Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab1BJSCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:02:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:48765 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab1BJSCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:02:03 -0500
Date: Thu, 10 Feb 2011 10:00:44 -0800
From: Greg KH <gregkh@suse.de>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, david@woodhou.se,
        david.woodhouse@intel.com
Subject: Re: [RFC PATCH 01/13] Intel(R) MEI Driver
Message-ID: <20110210180044.GD13795@suse.de>
References: <b9dded$htd8nk@orsmga002.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9dded$htd8nk@orsmga002.jf.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 01:54:57AM -0800, Oren Weil wrote:
> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig

Where is the description?

Where is the signed-off-by line?

> index b7980a8..0a54b26 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -1144,5 +1144,16 @@ config RAMOOPS
>  	  This enables panic and oops messages to be logged to a circular
>  	  buffer in RAM where it can be read back at some later point.
>  
> +config INTEL_MEI
> +	tristate "Intel(R) Management Engine Interface (Intel(R) MEI)"

What's with the (R) symbols everywhere?  The Linux kernel is not a place
for this.

> +	default m

No, this is not a valid default.

> +	depends on EXPERIMENTAL && X86
> +	help
> +	  If you have an Intel(R) ME chip in your system 

Trailing whitespace, which shows that you didn't take the simple time to
run your patches through scripts/checkpatch.pl, so why should we take
time to review them?

And you don't add a config option as your first patch, it does nothing
at this point in time for any code that is existing in the kernel.

greg k-h
