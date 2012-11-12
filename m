Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419Ab2KLHge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 02:36:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35098 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2KLHgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 02:36:32 -0500
Message-ID: <50A0A71D.9060102@linaro.org>
Date: Mon, 12 Nov 2012 13:07:01 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: Jaehoon Chung <jh80.chung@samsung.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH 0/8] Fix coding style in sdhci.c
References: <1352461198-21941-1-git-send-email-tushar.behera@linaro.org> <50A05DE9.8070907@samsung.com> <50A07D30.4030705@linaro.org> <87a9unnvl1.fsf@octavius.laptop.org>
In-Reply-To: <87a9unnvl1.fsf@octavius.laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 12:42 PM, Chris Ball wrote:
> Hi,
> 
> On Sun, Nov 11 2012, Tushar Behera wrote:
>> Yes, I can do that. I did split it specifically so that we could drop
>> any patches if required.
>>
>> I will wait for a word from Chris regarding what he prefers.
> 
> I would want to merge one patch, but I'm afraid I don't generally want
> to merge changes like these.  sdhci.c is one of the most modified files
> in drivers/mmc, so a change like this can create merge conflicts that
> require many people to update their work, and that's not worth it.
> 
> Thanks,
> 
> - Chris.
> 
Thanks for the information.

-- 
Tushar Behera
