Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491Ab2HHOk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:40:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44239 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab2HHOkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:40:25 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] spi: omap2-mcspi: In case of dma errors fall back to pio
Thread-Topic: [PATCH] spi: omap2-mcspi: In case of dma errors fall back to
 pio
Thread-Index: AQHNai25xNDOmd1lUEKgsiDgO5BXj5dPtkow
Date: Wed, 8 Aug 2012 14:39:11 +0000
Deferred-Delivery: Wed, 8 Aug 2012 14:39:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E987576@DBDE01.ent.ti.com>
References: <1343197229-15188-1-git-send-email-shubhrajyoti@ti.com>
In-Reply-To: <1343197229-15188-1-git-send-email-shubhrajyoti@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 11:50:29, Datta, Shubhrajyoti wrote:
> In case there are dma errors currently the driver exits.
> Make the spi driver fall back to pio mode in case of dma errors.
> 
> If the DMA engine is not selected the driver
> exits.This patch makes the spi fall back to pio in that case.
> 
> Also adds a field dma_unusable to struct omap2_mcspi.
>  
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>

I have tested this patch for SPI PIO mode on AM335x EVM.

Acked-by: Philip, Avinash <avinashphilip@ti.com>

