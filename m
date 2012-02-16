Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab2BPJNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:13:13 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39105 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239Ab2BPJNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:13:02 -0500
Message-ID: <4F3CC899.4070302@monstr.eu>
Date: Thu, 16 Feb 2012 10:12:57 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
CC: Ohad Ben-Cohen <ohad@wizery.com>, LKML <linux-kernel@vger.kernel.org>,
        John Williams <john.williams@petalogix.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "Grosen, Mark" <mgrosen@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: remoteproc: Load coprocessor code to the specific main memory
 location
References: <4F1EE861.4030405@monstr.eu> <CAK=Wgba5kT8AwLtuHyosucYnWf-EA+xpE1kzmssfhSC7ZXQA=g@mail.gmail.com> <4F1FF870.3000105@monstr.eu> <CAK=WgbZwaxMPsMiNcq5yFvBLrcODqGgDT6b=mmQ91JBVtTEyXA@mail.gmail.com> <4F200F64.9060203@monstr.eu> <CAK=WgbZDADRf1OF=uWbbsF+t2dx36tqj=kRftn5nd4RA7DtEnA@mail.gmail.com> <4F212E9E.9060807@monstr.eu> <CAK=WgbYMBDp3Qm8TErNrnDwn2ZTFt62+OuyyQvVE-jrnNsL6kg@mail.gmail.com> <4F391C1D.9020402@monstr.eu> <CAK=WgbYn6hrS4YLEdfp=0jSEfEwy-HkJmt5S06_j6gZFf0UTmQ@mail.gmail.com> <4F3BA962.9040109@monstr.eu> <4F3BC30A.4030301@monstr.eu>
In-Reply-To: <4F3BC30A.4030301@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Simek wrote:
> Michal Simek wrote:
>> Ohad Ben-Cohen wrote:
>>> On Mon, Feb 13, 2012 at 3:20 PM, Michal Simek <monstr@monstr.eu> wrote:
>>>> Here is how it is achieve
>>>>        ret = dma_declare_coherent_memory(&zynq_freertos.dev, 0,
>>>>                                0, 0x10000000, DMA_MEMORY_MAP);
>>>>
>>>> which is fully compatible with remoteproc.
>>>
>>> Great, this is what we've been doing with davinci too.
>>
>> Cool.
>>
>>>
>>>> Do you have any example of using it?
>>>
>>> What exactly are you looking for ? RTOS or Linux side ?
>>
>> Both side will be great. Rtos is freertos.
>>
>>>
>>> On the Linux side, you can just make the rpmsg sample work (it's part
>>> of the rpmsg patch set). For the RTOS side, feel free to just take our
>>> code (it's BSD licensed and hosted on github) and adapt it to your
>>> environment.
>>
>> You mean that server_sample and rpmsg_omx right?
>> I have also found rpmsg-omx demo application.
>> What I am missing is how to probe rpmsg bus.
>> Do you have any working example?
>>
>> Communication between cpus is done through swirqs. I have test sending 
>> it from linux to rtos.
> 
> ok. How that rpmsg channels are created? Is it based on data sent from 
> remoteproc?
> Or based on resource table?

I should be more specific. Can you point me to remoteproc code which publish
remote service based on them Linux rpmsg driver will be probed? It is rtos part of code.
In your ELCE presentation is called rpmsg-client-sample service.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
