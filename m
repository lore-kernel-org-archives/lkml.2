Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab1JYCku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 22:40:50 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:54158 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754646Ab1JYCkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 22:40:37 -0400
X-Sasl-enc: POkLS0H+h0ntoy+f1fzijSPH58vdsqkiswnvlZjbEwy2 1319510436
Date: Tue, 25 Oct 2011 04:28:52 +0200
From: Greg KH <greg@kroah.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: gregkh@suse.de, Nhan H Mai <nhan.h.mai@intel.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        alan@linux.intel.com
Subject: Re: [PATCH] serial/8250_pci: add a quirk for the kt serial controller
Message-ID: <20111025022852.GB32457@kroah.com>
References: <20111023222711.22713.11434.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111023222711.22713.11434.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 03:27:16PM -0700, Dan Williams wrote:
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2492,6 +2492,7 @@
>  #define PCI_DEVICE_ID_INTEL_IOAT	0x1a38
>  #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MIN	0x1c41
>  #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX	0x1c5f
> +#define PCI_DEVICE_ID_INTEL_PATSBURG_KT	0x1d3d
>  #define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_0	0x1d40
>  #define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_1	0x1d41
>  #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_XHCI	0x1e31

Based on the comment at the top of this file, you shouldn't add this
entry to it.

Care to redo the patch without that change?

thanks,

greg k-h
