Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377Ab2INLZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:25:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64814 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050Ab2INLZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:25:27 -0400
MIME-Version: 1.0
In-Reply-To: <1347592503.1943.17.camel@vkoul-udesk3>
References: <1347000288-20441-1-git-send-email-inderpal.singh@linaro.org>
	<1347592503.1943.17.camel@vkoul-udesk3>
Date: Fri, 14 Sep 2012 16:55:26 +0530
Message-ID: <CANuQgHEz1jt=gmhxUsLev8Vu1G9EeZUqiaREYEhLPBtJj257=Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] DMA: PL330: Clock and runtime cleanup
From: Chander Kashyap <chander.kashyap@linaro.org>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Inderpal Singh <inderpal.singh@linaro.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, patches@linaro.org, boojin.kim@samsung.com,
        jassisinghbrar@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 September 2012 08:45, Vinod Koul <vinod.koul@linux.intel.com> wrote:
> On Fri, 2012-09-07 at 12:14 +0530, Inderpal Singh wrote:
>> The controller clock is being managed at AMBA bus level probe/remove and
>> pm_runtime/suspend functions. The existing driver does the clock enable/disable
>> again in the same code paths, which unneccessarily increments the usage count of
>> the clock for the same device.
>>
>> The following patches remove the redundant clock enable/disable from the driver.
> Looks good, any tested by before I apply this.. Kukjin?
if it matters,
Tested-by: Chander Kashyap <chander.kashyap@linaro.org>

>>
>> Inderpal Singh (2):
>>   DMA: PL330: Remove controller clock enable/disable
>>   DMA: PL330: Remove redundant runtime_suspend/resume functions
>>
>>  drivers/dma/pl330.c |   73 ++++-----------------------------------------------
>>  1 file changed, 5 insertions(+), 68 deletions(-)
>>
>
>
> --
> ~Vinod
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
with warm regards,
Chander Kashyap
