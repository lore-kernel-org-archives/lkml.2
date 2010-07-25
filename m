Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab0GYRu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 13:50:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab0GYRu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 13:50:26 -0400
Message-ID: <4C4C7966.2000003@redhat.com>
Date: Sun, 25 Jul 2010 14:50:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100720 Red Hat/3.1.1-1.el6 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.35-rc6] quiesce EDAC initialisation on desktop/mobile i7
References: <AANLkTin5f_mfe+Jjo7Uv0mLyoQzM3KR3FK5=ejjTg=7D@mail.gmail.com> <20100724105642.GA8059@liondog.tnic>
In-Reply-To: <20100724105642.GA8059@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-07-2010 07:56, Borislav Petkov escreveu:
> From: Daniel J Blueman <daniel.blueman@gmail.com>
> Date: Fri, Jul 23, 2010 at 11:16:52PM +0100
> 
>> Hi Linus,
>>
>> A small fixlet for 2.6.35-rc7/final.
>>
>> ---
>>
>> Don't print failure to detect Core i7 EDAC facilities to the console at boot
>> time, most often occurring on Core i7 desktops and laptops.
>>
>> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

Seems ok to me.

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

>>
>> diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
>> index cc9357d..e0187d1 100644
>> --- a/drivers/edac/i7core_edac.c
>> +++ b/drivers/edac/i7core_edac.c
>> @@ -1300,7 +1300,7 @@ int i7core_get_onedevice(struct pci_dev **prev, int devno,
>>  		if (devno == 0)
>>  			return -ENODEV;
>>
>> -		i7core_printk(KERN_ERR,
>> +		i7core_printk(KERN_INFO,
>>  			"Device not found: dev %02x.%d PCI ID %04x:%04x\n",
>>  			dev_descr->dev, dev_descr->func,
>>  			PCI_VENDOR_ID_INTEL, dev_descr->dev_id);
>>
> 
> Adding the driver maintainer to CC. Please, try doing that in the
> future,
> 
> Thanks.
> 

