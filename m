Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab0FTBak (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 21:30:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45010 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab0FTBai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 21:30:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xbweHEPQNahqHFVwdxflMMLZSQJkYSrz1sNWUOaybb5SIoFQgllDpoQ/toseQgYxRv
         Zf+boSkwxxZ/VJanZ23yJK5zB9uuAAT1wAWCf8D+slseMBfdWLg17koFBXOiZYjJERaz
         lJdHsPpIzlQOKdavwcx8aT3WdOFgKeUR5zVEY=
Message-ID: <4C1D6F34.5050703@gmail.com>
Date: Sun, 20 Jun 2010 09:30:28 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>,
       Andrew Morton <akpm@linux-foundation.org>
CC: rtc-linux@googlegroups.com, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>
Subject: Re: [rtc-linux] [PATCH v3] RTC: Add JZ4740 RTC driver
References: <1276924111-11158-16-git-send-email-lars@metafoo.de> <1276975790-25623-1-git-send-email-lars@metafoo.de> <4C1D6B27.7070408@gmail.com> <4C1D6D76.8030109@metafoo.de>
In-Reply-To: <4C1D6D76.8030109@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars-Peter Clausen :
> Wan ZongShun wrote:
>>> This patch adds support for the RTC unit on JZ4740 SoCs.
>>>
>>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>>> Cc: Alessandro Zummo <a.zummo@towertech.it>
>>> Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
>>> Cc: rtc-linux@googlegroups.com
>>>
>>> -- 
>>> Changes since v1
>>> - Use dev_get_drvdata directly instead of wrapping it in dev_to_rtc
>>> - Add common implementation for jz4740_rtc_{alarm,update}_irq_enable
>>> - Check whether rtc structure could be allocated
>>> - Remove deadlocks which could occur if the HW was broken
>>>
>>> Changes since v2
>>> - Use kzalloc instead of kmalloc
>>> - Propagate errors in jz4740_rtc_reg_write up to its callers
>> Acked-by: Wan ZongShun <mcuos.com@gmail.com>
>>
>> Andrew, the v3 patch has fixed some above issues, it looks good to me
>> now.
>> Could you please consider merging it to your git tree?
>>
> Hi
> 
> As written in the introduction mail to this thread it would be good if
> the majority of the patches could go through Ralfs tree.
> So if the patch is good an "Acked-by:" would be preferable.
> 
Okay, Sound like good to me, please do you want to do.
Acked-by: Wan ZongShun <mcuos.com@gmail.com>

> Thanks,
> - Lars
> 
> 
> 

