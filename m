Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab2GYHoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 03:44:06 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37301 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2GYHoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 03:44:04 -0400
MIME-Version: 1.0
In-Reply-To: <1343201406.30161.10.camel@joe2Laptop>
References: <1343200277-14385-1-git-send-email-chenbdchenbd@gmail.com>
	<1343201406.30161.10.camel@joe2Laptop>
Date: Wed, 25 Jul 2012 15:44:02 +0800
Message-ID: <CAEAuANO7itUw64z=w9ve_suvQBoPirnmZ_5WBbc=Tn=ESeG6OA@mail.gmail.com>
Subject: Re: [PATCH] fixed coding style issues
From: Baodong Chen <chenbdchenbd@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i want to participate in and to start from
fixing simple issues!
how could i choose issues form checkpatch's output to find which
should be fixed which are
not?
or checkpatch.pl should be updated??

On Wed, Jul 25, 2012 at 3:30 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2012-07-25 at 15:11 +0800, Baodong Chen wrote:
>> Fexed coding style issues from scripts/checkpatch.pl in drivers/input
>
> Not all checkpatch messages need to be "fexed". :)
>
> Please use some taste and judgment before submitting
> patches based solely on checkpatch output.
>
>> diff --git a/drivers/input/apm-power.c b/drivers/input/apm-power.c
> []
>> @@ -33,7 +33,7 @@ static void system_power_event(unsigned int keycode)
>>  }
>>
>>  static void apmpower_event(struct input_handle *handle, unsigned int
>> type,
>> -                     unsigned int code, int value)
>> +                     unsigned int code, int value)
>
> Perhaps prefer alignment to immediately after open parenthesis.
>
>> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> []
>> @@ -547,16 +547,44 @@ static int handle_eviocgbit(struct input_dev *dev,
>>
>>       switch (type) {
>>
>> -     case      0: bits = dev->evbit;  len = EV_MAX;  break;
> []
>> +     case      0:
>> +             bits = dev->evbit;
>> +             len = EV_MAX;
>> +             break;
>
> not all that better really.
>
>> @@ -567,8 +595,8 @@ static int handle_eviocgbit(struct input_dev *dev,
>>       if (type == EV_KEY && size == OLD_KEY_MAX) {
>>               len = OLD_KEY_MAX;
>>               if (printk_timed_ratelimit(&keymax_warn_time, 10 * 1000))
>> -                     pr_warning("(EVIOCGBIT): Suspicious buffer size %u,
>> "
>> -                                "limiting output to %zu bytes. See "
>> +                     pr_warn("(EVIOCGBIT): Suspicious buffer size %u, "
>> \
>> +                                "limiting output to %zu bytes. See " \
>
> The line continuations are also not necessary and I think are
> really ugly.  Just coalesce the format.
>
>>
>> "http://userweb.kernel.org/~dtor/eviocgbit-bug.html\n",
>
> dead link I think.
>
>> diff --git a/drivers/input/ff-core.c b/drivers/input/ff-core.c
> []
>> @@ -138,8 +138,8 @@ int input_ff_upload(struct input_dev *dev, struct
>> ff_effect *effect,
>>
>>       if (effect->id == -1) {
>>               for (id = 0; id < ff->max_effects; id++)
>> -                  if (!ff->effect_owners[id])
>> -                     break;
>> +                     if (!ff->effect_owners[id])
>> +                             break;
>
> Better surrounded by braces too.
>
> cheers, Joe
>
>
