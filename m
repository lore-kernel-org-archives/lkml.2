Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab1DFPUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 11:20:15 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:65459 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab1DFPUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 11:20:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=efqIbpSwloxPYxt3GOPYt8UPSjh5vs42MGXQpkz+IKgsbzEmr8D4FBVAzIOw2U2qOO
         hkW8VGesY3P5fAj2H5rrdO2eEcs4M+JXwwfSXs2NJ368u2C9BXf8FjdxWjoGpQcPcb/f
         N/QJd2JVomPBv8m/BOlRD/3DQgg5i2xsZjn8s=
Message-ID: <4D9C826C.5050802@gmail.com>
Date: Wed, 06 Apr 2011 08:10:36 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: trivial@kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [RFC 1/5]arch/arm/common/Makefile Remove unused config in the
 Makefile.
References: <1302022702-24541-1-git-send-email-justinmattock@gmail.com> <20110406080522.GZ13963@pengutronix.de>
In-Reply-To: <20110406080522.GZ13963@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2011 01:05 AM, Uwe Kleine-König wrote:
> Hello,
>
> On Tue, Apr 05, 2011 at 09:58:18AM -0700, Justin P. Mattock wrote:
>> The patch below removes an unused config variable found by using a kernel
>> cleanup script.
>> Note: I did try to cross compile these but hit erros while doing so..
>> (gcc is not setup to cross compile) and am unsure if anymore needs to be done.
>> Please have a look if/when anybody has free time.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>> CC: Russell King<linux@arm.linux.org.uk>
>> CC: linux-arm-kernel@lists.infradead.org
> The file was removed by commit
>
> 	6d803ba (ARM: 6483/1: arm&  sh: factorised duplicated clkdev.c)
>
> (added the persons involved to Cc).
>
> Acked-by: Uwe Kleine-König<u.kleine-koenig@pengutronix.de>
>
> Thanks
> Uwe

o.k.!! Thanks for having a look at this..

>
>> ---
>>   arch/arm/common/Makefile |    1 -
>>   1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/common/Makefile b/arch/arm/common/Makefile
>> index e7521bca..6ea9b6f 100644
>> --- a/arch/arm/common/Makefile
>> +++ b/arch/arm/common/Makefile
>> @@ -16,5 +16,4 @@ obj-$(CONFIG_SHARP_SCOOP)	+= scoop.o
>>   obj-$(CONFIG_ARCH_IXP2000)	+= uengine.o
>>   obj-$(CONFIG_ARCH_IXP23XX)	+= uengine.o
>>   obj-$(CONFIG_PCI_HOST_ITE8152)  += it8152.o
>> -obj-$(CONFIG_COMMON_CLKDEV)	+= clkdev.o
>>   obj-$(CONFIG_ARM_TIMER_SP804)	+= timer-sp.o
>> --
>> 1.7.4.2
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
>

Justin P. Mattock
