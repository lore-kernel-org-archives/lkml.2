Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab1EAP7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 11:59:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab1EAP7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 11:59:49 -0400
Message-ID: <4DBD8367.6010901@redhat.com>
Date: Sun, 01 May 2011 12:59:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Thunderbird/3.1.7
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, crope@iki.fi,
        tvboxspy@gmail.com
Subject: Re: [PATCH 0/5] get rid of on-stack dma buffers (part1)
References: <1300657852-29318-1-git-send-email-florian@mickler.org>	<20110430205405.4beb7d33@schatten.dmk.lab>	<4DBC8D9C.2090802@redhat.com> <20110501123851.0ab6b799@schatten.dmk.lab>
In-Reply-To: <20110501123851.0ab6b799@schatten.dmk.lab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 01-05-2011 07:38, Florian Mickler escreveu:
> On Sat, 30 Apr 2011 19:30:52 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
>> Hi Florian,
>>
>> Em 30-04-2011 15:54, Florian Mickler escreveu:
>>> Hi Mauro!
>>>
>>> I just saw that you picked up some patches of mine. What about these?
>>> These are actually tested...
>>
>> I'm still in process of applying the pending patches. Due to patchwork.kernel.org
>> troubles (including the loss of about 270 patches from its SQL database only 
>> recovered yesterday[1]), I have a long backlog. So, I'm gradually applying the remaing
>> stuff. It will take some time though, and it will depend on patchwork mood, but I intend
>> to spend some time during this weekend to minimize the backlog.
>>
>>
>> Cheers,
>> Mauro
>>
>> [1] The recover lost the email's body/SOB, so I've wrote a script to use my email
>> queue to get the data, using patchwork just to mark what patches were already
>> processed. This increses the time I have to spend on each patch, as I need to run
>> a script to match the patchwork patch with the patch ID inside my email queue.
>>
> 
> Ah ok, no time pressure over here.. just wanted to make sure
> that these don't get lost.

I think I've applied your series yesterday. Yet, patchwork is currently at bad mood, and it is
not allowing to mark your patches as applied (and the previous series as superseded).

I suspect that I'll need to completely abandon patchwork and work on a new way for handling it
that doesn't depend (nor will update) patchwork.kernel.org.

Mauro.
