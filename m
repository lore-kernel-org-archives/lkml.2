Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab2KLEhn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 23:37:43 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:41968 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2KLEhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 23:37:41 -0500
Message-ID: <50A07D30.4030705@linaro.org>
Date: Mon, 12 Nov 2012 10:08:08 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jaehoon Chung <jh80.chung@samsung.com>
CC: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, cjb@laptop.org,
        patches@linaro.org
Subject: Re: [PATCH 0/8] Fix coding style in sdhci.c
References: <1352461198-21941-1-git-send-email-tushar.behera@linaro.org> <50A05DE9.8070907@samsung.com>
In-Reply-To: <50A05DE9.8070907@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 07:54 AM, Jaehoon Chung wrote:
> Hi Tushar,
> 
> Could you make one patch? Why do you separate patches?
> 

Yes, I can do that. I did split it specifically so that we could drop
any patches if required.

I will wait for a word from Chris regarding what he prefers.


> Best Regards,
> Jaehoon Chung
> 
> On 11/09/2012 08:39 PM, Tushar Behera wrote:
>> Documents/CodingStyle Chapter 3 recommends usage of braces for both
>> if and else statements if any of the branches contains multiple
>> statements.
>>
>> Cleaning up drivers/mmc/host/sdhci.c for all these occurrences.
>>
>> Tushar Behera (8):
>>   mmc: sdhci: fix coding style in sdhci_calc_timeout
>>   mmc: sdhci: fix coding style in sdhci_set_transfer_mode
>>   mmc: sdhci: fix coding style in sdhci_finish_data
>>   mmc: sdhci: fix coding style in sdhci_set_clock
>>   mmc: sdhci: fix coding style in sdhci_do_set_ios
>>   mmc: sdhci: fix coding style in sdhci_execute_tuning
>>   mmc: sdhci: fix coding style in sdhci_data_irq
>>   mmc: sdhci: fix coding style in sdhci_add_host
>>
>>  drivers/mmc/host/sdhci.c |   58 +++++++++++++++++++++++++--------------------
>>  1 files changed, 32 insertions(+), 26 deletions(-)
>>
> 


-- 
Tushar Behera
