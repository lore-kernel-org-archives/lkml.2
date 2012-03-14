Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab2CNHnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:43:51 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42232 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab2CNHnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:43:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120309174411.GI3852@pengutronix.de>
References: <1331306449-28591-1-git-send-email-javier.martin@vista-silicon.com>
	<20120309174411.GI3852@pengutronix.de>
Date: Wed, 14 Mar 2012 08:43:45 +0100
Message-ID: <CACKLOr0XzE0PZk=k5xQQvOA_5dfBk1mYDVyKCep36=3w7ugwWg@mail.gmail.com>
Subject: Re: [PATCH v3 00/13] dmaengine: imx-dma: merge dma arch code into dmaengine.
From: javier Martin <javier.martin@vista-silicon.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, vinod.koul@intel.com, linux@arm.linux.org.uk,
        kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 March 2012 18:44, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Fri, Mar 09, 2012 at 04:20:36PM +0100, Javier Martin wrote:
>> The following series have to be applied on top of the following patches:
>> [PATCH v2 1/2] dmaengine: Add support for MEMCPY for imx-dma.
>> [PATCH v3 2/2] dmaengine: Add support for multiple descriptors for imx-dma.
>>
>> As discussed with Vinod and Sascha, the file 'arch/arm/mach-imx/dma-v1.c'
>> is deprecated and no new patches are accepted for it.
>>
>> This series merges this code into the imx-dma.c dmaengine driver.
>
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
>

Vinod,
I think with Sascha's ack, this series is ready to be merged. It's
quite important for us that it makes it for 3.4.

Please, don't forget the following patch too, which is meant to be
applied on top of this series:

[PATCH] dmaengine: i.MX: Add support for interleaved transfers.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
