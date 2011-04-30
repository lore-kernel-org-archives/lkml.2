Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab1D3WbJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 18:31:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab1D3WbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 18:31:07 -0400
Message-ID: <4DBC8D9C.2090802@redhat.com>
Date: Sat, 30 Apr 2011 19:30:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Thunderbird/3.1.7
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, crope@iki.fi,
        tvboxspy@gmail.com
Subject: Re: [PATCH 0/5] get rid of on-stack dma buffers (part1)
References: <1300657852-29318-1-git-send-email-florian@mickler.org> <20110430205405.4beb7d33@schatten.dmk.lab>
In-Reply-To: <20110430205405.4beb7d33@schatten.dmk.lab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

Em 30-04-2011 15:54, Florian Mickler escreveu:
> Hi Mauro!
> 
> I just saw that you picked up some patches of mine. What about these?
> These are actually tested...

I'm still in process of applying the pending patches. Due to patchwork.kernel.org
troubles (including the loss of about 270 patches from its SQL database only 
recovered yesterday[1]), I have a long backlog. So, I'm gradually applying the remaing
stuff. It will take some time though, and it will depend on patchwork mood, but I intend
to spend some time during this weekend to minimize the backlog.


Cheers,
Mauro

[1] The recover lost the email's body/SOB, so I've wrote a script to use my email
queue to get the data, using patchwork just to mark what patches were already
processed. This increses the time I have to spend on each patch, as I need to run
a script to match the patchwork patch with the patch ID inside my email queue.

> 
> Regards,
> Flo
> 
>  On Sun, 20 Mar 2011 22:50:47 +0100
> Florian Mickler <florian@mickler.org> wrote:
> 
>> Hi Mauro!
>>
>> These are the patches which got tested already and 
>> should be good to go. [first batch of patches]
>>
>> I have another batch with updated patches (dib0700, gp8psk, vp702x)
>> where I did some more extensive changes to use preallocated memory.
>> And a small update to the vp7045 patch.
>>
>> Third batch are the patches to opera1, m920x, dw2102, friio,
>> a800 which I left as is, for the time beeing. 
>> Regards,
>> Flo
>>
>> Florian Mickler (5):
>>   [media] ec168: get rid of on-stack dma buffers
>>   [media] ce6230: get rid of on-stack dma buffer
>>   [media] au6610: get rid of on-stack dma buffer
>>   [media] lmedm04: correct indentation
>>   [media] lmedm04: get rid of on-stack dma buffers
>>
>>  drivers/media/dvb/dvb-usb/au6610.c  |   22 ++++++++++++++++------
>>  drivers/media/dvb/dvb-usb/ce6230.c  |   11 +++++++++--
>>  drivers/media/dvb/dvb-usb/ec168.c   |   18 +++++++++++++++---
>>  drivers/media/dvb/dvb-usb/lmedm04.c |   35 +++++++++++++++++++++++------------
>>  4 files changed, 63 insertions(+), 23 deletions(-)
>>

