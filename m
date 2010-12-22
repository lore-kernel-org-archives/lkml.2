Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab0LVEnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 23:43:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab0LVEnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 23:43:40 -0500
Date: Tue, 21 Dec 2010 20:44:25 -0800
From: Greg KH <gregkh@suse.de>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, qi.wang@intel.com,
        yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH] pch_phub: add new device ML7213
Message-ID: <20101222044424.GC19006@suse.de>
References: <1292992394-3264-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292992394-3264-1-git-send-email-tomoya-linux@dsn.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 01:33:14PM +0900, Tomoya MORINAGA wrote:
> @@ -688,6 +720,7 @@ static int pch_phub_resume(struct pci_dev *pdev)
>  
>  static struct pci_device_id pch_phub_pcidev_id[] = {
>  	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_PCH1_PHUB)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_ROHM, PCI_DEVICE_ID_ROHM_ML7213_PHUB)},

Put the device type here in the device table, so you don't have to check
for it again in the probe function.  That way you can save some code and
keep things simpler and more obvious in the future when adding new
device ids, that you also have to pick the type for it.

thanks,

greg k-h
