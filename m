Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab0LRRyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 12:54:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068Ab0LRRyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 12:54:17 -0500
Date: Sat, 18 Dec 2010 09:52:27 -0800
From: Greg KH <gregkh@suse.de>
To: Robert Morell <rmorell@nvidia.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Benoit Goby <benoit@android.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>,
        Olof Johansson <olof@lixom.net>, Erik Gilling <konkers@android.com>,
        Colin Cross <ccross@android.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 2/2] USB: ehci: tegra: Align DMA transfers to 32
 bytes
Message-ID: <20101218175227.GC7225@suse.de>
References: <1292623129-26361-1-git-send-email-rmorell@nvidia.com>
 <1292636971-17701-3-git-send-email-rmorell@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292636971-17701-3-git-send-email-rmorell@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 05:49:31PM -0800, Robert Morell wrote:
> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h
> @@ -975,6 +975,7 @@ extern int usb_disabled(void);
>  #define URB_SETUP_MAP_SINGLE	0x00100000	/* Setup packet DMA mapped */
>  #define URB_SETUP_MAP_LOCAL	0x00200000	/* HCD-local setup packet */
>  #define URB_DMA_SG_COMBINED	0x00400000	/* S-G entries were combined */
> +#define URB_ALIGNED_TEMP_BUFFER	0x00800000	/* Temp buffer was alloc'd */

This should go in the previous patch, right?

thanks,

greg k-h
