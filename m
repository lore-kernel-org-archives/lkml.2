Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2GWLYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 07:24:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49923 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306Ab2GWLYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 07:24:08 -0400
Date: Mon, 23 Jul 2012 13:24:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: wei_wang@realsil.com.cn
Cc: gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers/misc: Add realtek card reader core driver
Message-ID: <20120723112403.GA3421@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, wei_wang@realsil.com.cn,
	gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
	linux-kernel@vger.kernel.org
References: <1343036558-8189-1-git-send-email-wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1343036558-8189-1-git-send-email-wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 05:42:38PM +0800, wei_wang@realsil.com.cn wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> Realtek card reader core driver is the bus driver for Realtek
> driver-based card reader, which supplies adapter layer to
> be used by lower-level pci/usb card reader and upper-level
> sdmmc/memstick host driver.
> 
> Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>

Applying: drivers/misc: Add realtek card reader core driver
/home/boris/kernel/linux-2.6/.git/rebase-apply/patch:128: new blank line at EOF.
+
/home/boris/kernel/linux-2.6/.git/rebase-apply/patch:822: new blank line at EOF.
+
warning: 2 lines add whitespace errors.

-- 
Regards/Gruss,
Boris.
