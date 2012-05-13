Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2EMXDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 19:03:18 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49650 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab2EMXDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 19:03:17 -0400
MIME-Version: 1.0
In-Reply-To: <873974doi6.fsf@devron.myhome.or.jp>
References: <1336907039-18638-1-git-send-email-linkinjeon@gmail.com>
	<1336924011.31383.6.camel@joe2Laptop>
	<87bolsdpzk.fsf@devron.myhome.or.jp>
	<1336926115.2656.2.camel@joe2Laptop>
	<873974doi6.fsf@devron.myhome.or.jp>
Date: Mon, 14 May 2012 08:03:16 +0900
Message-ID: <CAKYAXd8cPCLvdw-btWmjo=sGQ+tH7Z+6V9NiECwGc5RQxzZp1A@mail.gmail.com>
Subject: Re: [PATCH 2/2] fat: use fat_msg_ratelimit in fat__get_entry.
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/14, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Joe Perches <joe@perches.com> writes:
>
>>> > Please don't split format strings.
>>> > It's much harder to grep.
>>>
>>> Please fight with 80 columns guys before requesting it.
>>
>> That battle is long over.
>>
>> from Documentation/CodingStyle:
>>
>> 		Chapter 2: Breaking long lines and strings
>>
>> []
>>
>> The limit on the length of lines is 80 columns and this is a strongly
>> preferred limit.
>> []
>> However, never break user-visible strings such as
>> printk messages, because that breaks the ability to grep for them.
>
> Oh, I see. Namjae, can you adjust the patches to adjust for this?
> I don't care either one, so you can add the following if you tweaked
> patches.
Hi. Ogawa.
Okay, I will send you v2 patches for this.
Thanks for your help.
>
> Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
