Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab2IDPIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:08:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56412 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932181Ab2IDPIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:08:18 -0400
Date: Tue, 4 Sep 2012 11:08:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] USB/host: Cleanup unneccessary irq disable code
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A174713@SHSMSX101.ccr.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.1209041106290.1605-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Sep 2012, Liu, Chuansheng wrote:

> From: liu chuansheng <chuansheng.liu@intel.com>
> Subject: [PATCH] USB/host: Cleanup unneccessary irq disable code
> 
> Because the IRQF_DISABLED as the flag is now a NOOP and has been
> deprecated and in hardirq context the interrupt is disabled.
> 
> so in usb/host code:
> Removing the usage of flag IRQF_DISABLED;
> Removing the calling local_irq save/restore actions in irq
> handler usb_hcd_irq();
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

