Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab1E3IRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 04:17:23 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:43236 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755707Ab1E3IRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 04:17:21 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Greg KH'" <gregkh@suse.de>
Cc: "'Alan Cox'" <alan@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <qi.wang@intel.com>,
        <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>, <toshiharu-linux@dsn.okisemi.com>
References: <1306741324-4562-1-git-send-email-tomoya-linux@dsn.okisemi.com> <20110530074722.GA7947@suse.de>
Subject: RE: [PATCH] 8250_pci: add -ENODEV code for Intel EG20T PCH
Date: Mon, 30 May 2011 17:17:19 +0900
Message-ID: <346D35FD8BD841329CFDA7803DDB899E@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcwenbTdqq1H3weGQvy9Xx/lbjyo3QAAJKRA
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
In-Reply-To: <20110530074722.GA7947@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 30, 2011 4:47 PM,  Greg KH wrote:

> Why put this with an #if around it? 
> Why not just always not 
> bind to this driver as we have a "correct" driver for the 
> hardware now?

Let me clarify your saying.
Which does your saying mean,  (1) or (2) or else?

(1)
> +#if defined(CONFIG_SERIAL_PCH_UART) || defined(CONFIG_SERIAL_PCH_UART_MODULE)
> +		return -ENODEV;
> +#endif

(2)
> +	if ((dev->vendor == PCI_VENDOR_ID_INTEL && dev->device == 0x8811) ||
> +	   (dev->vendor == PCI_VENDOR_ID_INTEL && dev->device == 0x8812) ||
> +	   (dev->vendor == PCI_VENDOR_ID_INTEL && dev->device == 0x8813) ||
> +	   (dev->vendor == PCI_VENDOR_ID_INTEL && dev->device == 0x8814) ||
> +	   (dev->vendor == 0x10DB && dev->device == 0x8027) ||
> +	   (dev->vendor == 0x10DB && dev->device == 0x8028) ||
> +	   (dev->vendor == 0x10DB && dev->device == 0x8029) ||
> +	   (dev->vendor == 0x10DB && dev->device == 0x800C) ||
> +	   (dev->vendor == 0x10DB && dev->device == 0x800D))
> +		return -ENODEV;

With Best Regards,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

