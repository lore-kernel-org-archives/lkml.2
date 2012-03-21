Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab2CUHtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 03:49:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33047 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab2CUHtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 03:49:12 -0400
MIME-Version: 1.0
In-Reply-To: <1331723694.1727.28.camel@vkoul-udesk3>
References: <1331306449-28591-1-git-send-email-javier.martin@vista-silicon.com>
	<20120309174411.GI3852@pengutronix.de>
	<CACKLOr0XzE0PZk=k5xQQvOA_5dfBk1mYDVyKCep36=3w7ugwWg@mail.gmail.com>
	<1331723694.1727.28.camel@vkoul-udesk3>
Date: Wed, 21 Mar 2012 08:49:11 +0100
Message-ID: <CACKLOr0m5a2p5wzi1OnqnvfZVCP3sRC4b+iZk-ZoRu6rV5SEVw@mail.gmail.com>
Subject: Re: [PATCH v3 00/13] dmaengine: imx-dma: merge dma arch code into dmaengine.
From: javier Martin <javier.martin@vista-silicon.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, linux@arm.linux.org.uk,
        kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Vinod,
>> I think with Sascha's ack, this series is ready to be merged. It's
>> quite important for us that it makes it for 3.4.
>>
>> Please, don't forget the following patch too, which is meant to be
>> applied on top of this series:
>>
>> [PATCH] dmaengine: i.MX: Add support for interleaved transfers.
>>
> This is my merge queue which means I will merged it after the cookie
> fixes (hate rebasing that series again)

Do you think it will make it for 3.4?

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
