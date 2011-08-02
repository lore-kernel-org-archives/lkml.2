Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab1HBLmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:42:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967Ab1HBLmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:42:38 -0400
Message-ID: <4E37E2A0.9090109@redhat.com>
Date: Tue, 02 Aug 2011 08:42:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
CC: Joe Perches <joe@perches.com>, gregkh@suse.de, devel@driverdev.osuosl.org,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        Palash.Bandyopadhyay@conexant.com, ruslan@rpisarev.org.ua,
        Revent82@gmail.com
Subject: Re: [PATCH] Staging: cx25821: fix coding style issues
References: <1312191229-24718-1-git-send-email-leonidsbox@gmail.com> <1312215262.11635.15.camel@Joe-Laptop> <20110802171856.044cd78d@inspire>
In-Reply-To: <20110802171856.044cd78d@inspire>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 02-08-2011 06:18, Leonid V. Fedorenchik escreveu:
> Thanks for the review. I sent v2. I have a question, however...
> 
> On Mon, 01 Aug 2011 09:14:22 -0700
> Joe Perches <joe@perches.com> wrote:
> 
>> On Mon, 2011-08-01 at 17:33 +0800, Leonid V. Fedorenchik wrote:
>>> Fix too long lines in cx25821-audio.h and cx25821-core.c
>> []
>>> diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/staging/cx25821/cx25821-core.c
>> []
>>> @@ -972,8 +972,8 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
>>>  	dev->lmmio = ioremap(dev->base_io_addr, pci_resource_len(dev->pci, 0));
>>>  
>>>  	if (!dev->lmmio) {
>>> -		CX25821_ERR
>>> -		    ("ioremap failed, maybe increasing __VMALLOC_RESERVE in page.h\n");
>>> +		CX25821_ERR("ioremap failed, maybe increasing __VMALLOC_RESERVE"
>>> +								" in page.h\n");
>>
>> Please do not split formats.
> 
> What is the reason to not split formats?
> I can see that in Documentation/CodingStyle in Chapter 2 it is OK to split
> formats if it is not making readability worse.
> So, is it for the sake of readability or is it new coding style rule for the
> kernel that is not in documentation yet or something else or am I misunderstood
> something?

Breaking long printk lines break things like:
	git grep "__VMALLOC_RESERVE in page.h"


Cheers,
Mauro
