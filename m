Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2CIIAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 03:00:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35538 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab2CIIAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 03:00:35 -0500
MIME-Version: 1.0
In-Reply-To: <20120308200448.GR3852@pengutronix.de>
References: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
	<20120308200448.GR3852@pengutronix.de>
Date: Fri, 9 Mar 2012 09:00:35 +0100
Message-ID: <CACKLOr2_y9aw+-79d4FfKsOuiDdOvDHAanQ6j+qF4Ynf2r5rag@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] dmaengine: imx-dma: merge dma arch code into dmaengine.
From: javier Martin <javier.martin@vista-silicon.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, vinod.koul@intel.com, linux@arm.linux.org.uk,
        kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On 8 March 2012 21:04, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Wed, Mar 07, 2012 at 03:33:32PM +0100, Javier Martin wrote:
>> The following series have to be applied on top of the following patches:
>> [PATCH v2 1/2] dmaengine: Add support for MEMCPY for imx-dma.
>> [PATCH v3 2/2] dmaengine: Add support for multiple descriptors for imx-dma.
>>
>> As discussed with Vinod and Sascha, the file 'arch/arm/mach-imx/dma-v1.c'
>> is deprecated and no new patches are accepted for it.
>>
>> This series merges this code into the imx-dma.c dmaengine driver.
>>
>
> I can't find a branch to apply this on. Could you provide a git tree?

I'm developing and testing here:

git://git.infradead.org/users/vkoul/slave-dma.git next

> If you have to repost this series please consider using -M with git
> format-patch.

OK, thanks for the suggestion.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
