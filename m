Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab2GGDJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 23:09:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab2GGDJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 23:09:18 -0400
Message-ID: <4FF7A84D.5040006@redhat.com>
Date: Sat, 07 Jul 2012 00:09:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Du Changbin <changbin.du@gmail.com>
CC: mchehab@infradead.org, anssi.hannula@iki.fi, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Resend PATCH] media: rc: ati_remote.c: code style and compile
 warning fixing
References: <031601cd5be2$b8831fb0$29895f10$@gmail.com>
In-Reply-To: <031601cd5be2$b8831fb0$29895f10$@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 06-07-2012 22:49, Du Changbin escreveu:
>>> diff --git a/drivers/media/rc/ati_remote.c
> b/drivers/media/rc/ati_remote.c
>>> index 7be377f..0df66ac 100644
>>> --- a/drivers/media/rc/ati_remote.c
>>> +++ b/drivers/media/rc/ati_remote.c
>>> @@ -23,6 +23,8 @@
>>>     *                Vincent Vanackere <vanackere@lif.univ-mrs.fr>
>>>     *            Added support for the "Lola" remote contributed by:
>>>     *                Seth Cohn <sethcohn@yahoo.com>
>>> + *  Jul 2012: Du, Changbin <changbin.du@gmail.com>
>>> + *            Code style and compile warning fixing
>>
>> You shouldn't be changing the driver's authorship just due to codingstyle
>> and warning fixes. Btw, Please split Coding Style form Compilation
> warnings,
>> as they're two different matters.
> 
> Sorry, I didn't know this rule. I just want to make  a track for me. OK, I
> will resend this patch and remove me from it.
> BTW, I am looking for something to learn these basic rules when sending
> patches. Could you tell me where I can find it?

There are some rules at linuxtv wiki pages, others at the Kernel Documentation
dir and other not so explicit rules like the above that you'll get as you
continue contributing ;)

In opposite to other open source projects, the contribution history is the
git logs, and not inside the comments at the source code.


> Many thanks!
> [Du, Changbin]

Thanks,
Mauro
