Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab2GVWhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 18:37:46 -0400
Received: from ozlabs.org ([203.10.76.45]:55759 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab2GVWhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 18:37:45 -0400
From: Rusty Russell <rusty@ozlabs.org>
To: wei_wang@realsil.com.cn, gregkh@linuxfoundation.org,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Cc: Wei WANG <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 2/3] drivers/misc: Add realtek pci card reader driver
In-Reply-To: <1342691710-23164-1-git-send-email-wei_wang@realsil.com.cn>
References: <1342691710-23164-1-git-send-email-wei_wang@realsil.com.cn>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 20 Jul 2012 15:28:40 +0930
Message-ID: <87sjcnas8f.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2012 17:55:10 +0800, <wei_wang@realsil.com.cn> wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> Realtek PCI-E card reader driver adapts requests from upper-level
> sdmmc/memstick layer to the real physical card reader.

> +static int msi_en = 1;
> +module_param(msi_en, int, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(msi_en, "Enable MSI");
> +
> +static int adma_mode = 1;
> +module_param(adma_mode, int, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(adma_mode, "ADMA Mode");

These seem like they should be bool?

Cheers,
Rusty.
