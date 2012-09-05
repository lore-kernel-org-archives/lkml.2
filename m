Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994Ab2IFACY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 20:02:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58008 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab2IFACW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 20:02:22 -0400
Date: Wed, 5 Sep 2012 16:59:47 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] USB/host: Cleanup unneccessary irq disable code
Message-ID: <20120905235947.GA19050@kroah.com>
References: <27240C0AC20F114CBF8149A2696CBE4A174713@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A174713@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2012 at 09:39:56AM +0000, Liu, Chuansheng wrote:
> From: liu chuansheng <chuansheng.liu@intel.com>
> Subject: [PATCH] USB/host: Cleanup unneccessary irq disable code

Don't include the Subject: in the patch body again, that is pointless
and requires me to hand-edit the file.

> Because the IRQF_DISABLED as the flag is now a NOOP and has been
> deprecated and in hardirq context the interrupt is disabled.
> 
> so in usb/host code:
> Removing the usage of flag IRQF_DISABLED;
> Removing the calling local_irq save/restore actions in irq
> handler usb_hcd_irq();
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>

This patch is corrupted and can not be applied at all.  Please fix your
email client and try again.

greg k-h
