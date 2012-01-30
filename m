Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab2A3MXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 07:23:03 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44267 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab2A3MXA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 07:23:00 -0500
MIME-Version: 1.0
In-Reply-To: <1327914764.1527.15.camel@vkoul-udesk3>
References: <1326101570-3716-1-git-send-email-s.hauer@pengutronix.de>
	<1327914764.1527.15.camel@vkoul-udesk3>
Date: Mon, 30 Jan 2012 13:22:59 +0100
Message-ID: <CACKLOr3tx0Kc8rZzx5sp91wCmDcjOB0byW0c7KrWT7VF1g2NyQ@mail.gmail.com>
Subject: Re: [PATCH] fix starting of transfers in i.MX dma drivers
From: javier Martin <javier.martin@vista-silicon.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, Chris Ball <cjb@laptop.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 January 2012 10:12, Vinod Koul <vinod.koul@intel.com> wrote:
> On Mon, 2012-01-09 at 10:32 +0100, Sascha Hauer wrote:
>> This moves the start of transfers from tx_submit to issue_pending
>> for the i.MX dma drivers as requested by Vinoud here:
>>
>> https://lkml.org/lkml/2012/1/7/23
>>
>> This requires the users (mxcmmc and i.MX sound) to be fixed first.
>> So Chris, Mark, given your Ack I would suggest to send this via
>> Vinouds DMA tree.
>>
>> Sascha
>>
>> Sascha Hauer (4):
>>       mmc: mxcmmc: add missing dma_async_issue_pending
>>       ASoC: i.MX: Add missing dma_async_issue_pending
>>       dma: imx-dma: start transfer in issue_pending
>>       dma: imx-sdma: start transfer in issue_pending
>>
>>  drivers/dma/imx-dma.c           |    9 ++++-----
>>  drivers/dma/imx-sdma.c          |   11 +++++------
>>  drivers/mmc/host/mxcmmc.c       |    1 +
>>  sound/soc/imx/imx-pcm-dma-mx2.c |    1 +
>>  4 files changed, 11 insertions(+), 11 deletions(-)
>
> Thanks applied all.
>
> Fixed change log in 3 & 4, as Russell pointed out
>
> Got a conflict in 4, pls see that fix is right.

Hi Vinod,
could you please tell me where has this been merged?

I can't see it at git://git.infradead.org/users/vkoul/slave-dma.git

Thank you.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
