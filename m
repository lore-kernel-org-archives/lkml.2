Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab2AXBOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 20:14:37 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44310 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753382Ab2AXBOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 20:14:36 -0500
X-Sasl-enc: mo8MK2Zt64gqyuKi/bgXwjfBhQzKZW7XezsS3LZtoIDO 1327367675
Date: Mon, 23 Jan 2012 17:14:30 -0800
From: Greg KH <greg@kroah.com>
To: Seth Heasley <seth.heasley@intel.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, james.d.ralston@intel.com
Subject: Re: [PATCH 6/6] pci: irq and pci_ids patch for Intel Lynx Point
 DeviceIDs
Message-ID: <20120124011430.GA13171@kroah.com>
References: <201201231646.24194.seth.heasley@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201231646.24194.seth.heasley@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 04:46:24PM -0800, Seth Heasley wrote:
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2800,6 +2800,8 @@
>  #define PCI_DEVICE_ID_INTEL_82454NX     0x84cb
>  #define PCI_DEVICE_ID_INTEL_84460GX	0x84ea
>  #define PCI_DEVICE_ID_INTEL_IXP4XX	0x8500
> +#define PCI_DEVICE_ID_INTEL_LYNXPOINT_LPC_MIN	0x8c40
> +#define PCI_DEVICE_ID_INTEL_LYNXPOINT_LPC_MAX	0x8c5f

You forgot to read the top of this file.

