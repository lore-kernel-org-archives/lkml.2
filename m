Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab2GXGoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 02:44:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35449 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab2GXGoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 02:44:13 -0400
Date: Tue, 24 Jul 2012 08:44:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: wwang <wei_wang@realsil.com.cn>
Cc: gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers/misc: Add realtek card reader core driver
Message-ID: <20120724064409.GA15735@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	wwang <wei_wang@realsil.com.cn>, gregkh@linuxfoundation.org,
	devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
References: <1343036558-8189-1-git-send-email-wei_wang@realsil.com.cn>
 <20120723163340.GA4105@x1.osrc.amd.com>
 <500DF89E.6090501@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <500DF89E.6090501@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 09:21:34AM +0800, wwang wrote:
> Hi Borislav:
> 
> Realtek card reader supports not only SDMMC card, but also Memory
> stick. This part is the common code, so it is located in
> drivers/misc. There is also SDMMC-relevant code under CONFIG_MMC.
> And in the future, Memstick-relevant code will be added under
> CONFIG_MEMSTICK.

Ok, thanks for explaining.

Btw, the SDMMC part rtsx_sdmmc.c doesn't build here:
http://marc.info/?l=linux-kernel&m=134306261405814&w=2

Thanks.

-- 
Regards/Gruss,
    Boris.
