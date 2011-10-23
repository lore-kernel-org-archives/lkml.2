Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab1JWOay (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 10:30:54 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:10826 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab1JWOax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 10:30:53 -0400
Message-ID: <4EA424FF.50103@atmel.com>
Date: Sun, 23 Oct 2011 16:30:23 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: vinod.koul@intel.com
CC: linux-arm-kernel@lists.infradead.org, robherring2@gmail.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] dmaengine: Device Tree support for Atmel DMA
References: <1318438634-11826-1-git-send-email-nicolas.ferre@atmel.com> <4E9C258D.3030509@atmel.com>
In-Reply-To: <4E9C258D.3030509@atmel.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2011 02:54 PM, Nicolas Ferre :
> On 10/12/2011 06:57 PM, Nicolas Ferre :
>> This series add the device tree support to Atmel DMA controller driver:
>> at_hdmac.
>> The removal of platform data ease the conversion to device tree. It also have
>> the additional benefit of being simpler and cleaner.
>>
>> Nicolas Ferre (4):
>>       dmaengine: at_hdmac: platform data move to use .id_table
>>       dmaengine: at_hdmac: add device tree support
>>       ARM: at91/dma: remove platform data from DMA controller
>>       ARM: at91/dma: DMA controller registering with DT support
>>
>>  .../devicetree/bindings/dma/atmel-dma.txt          |   14 ++++
>>  arch/arm/mach-at91/at91sam9g45_devices.c           |   17 ++---
>>  arch/arm/mach-at91/at91sam9rl_devices.c            |    8 +--
>>  arch/arm/mach-at91/include/mach/at_hdmac.h         |   10 ---
>>  drivers/dma/at_hdmac.c                             |   76 +++++++++++++++++---
>>  drivers/dma/at_hdmac_regs.h                        |    8 ++
>>  6 files changed, 97 insertions(+), 36 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/dma/atmel-dma.txt
> 
> Vinod,
> 
> I have just rebased the dmaengine at_hdmac driver patches on top of your
> "next" branch as a "v4" series. I send it to you with Grant's "Acked-by"
> right now.

Vinod,

Ping?

Do you want me to provide you a git tree for those two patches?
Do you think it can make it for 3.2 merge window?

Best regards,
-- 
Nicolas Ferre
