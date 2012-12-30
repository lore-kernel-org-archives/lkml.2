Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2L3GYj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 01:24:39 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58866 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab2L3GYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 01:24:36 -0500
Message-ID: <50DFDE2A.3070800@ti.com>
Date: Sun, 30 Dec 2012 11:54:42 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: <ahemaily@gmail.com>
CC: <tony@atomide.com>, <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] arm :omap :DMA: fix a bug on reserving the omap SDMA
 channels
References: <1356813800-4705-1-git-send-email-ahemaily@gmail.com>
In-Reply-To: <1356813800-4705-1-git-send-email-ahemaily@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$subject
s/arm:omap/ARM: OMAP:

On Sunday 30 December 2012 02:13 AM, ahemaily@gmail.com wrote:
> From: ahemaily <ahemaily@gmail.com>
>
> The variable  dma_lch_count  used for comparison  (omap_dma_reserve_channels <= dma_lch_count)
> before it initialized to the value from omap_dma_dev_attr : d->lch_count.
s/it/it is

> I change the place of dma_lch_count initialization to be before the comparison.
>
s/I change the place of dma_lch_count initialization to be before the 
comparison./ Initialize dma_lch_count before it is being used for 
comparison.

> Signed-off-by: Abdelrahman Hemaily <ahemaily@gmail.com>
> ---
Change looks good to my eyes o.w

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

