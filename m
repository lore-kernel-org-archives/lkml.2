Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1GYWcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 18:32:11 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53386 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab1GYWcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 18:32:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAKYAXd-KftOw-YMoA82-75Yp6FNYAXmna+5Fxe0JCMmUB3+-bg@mail.gmail.com>
References: <CAKYAXd-Tg7hXy3zHRtXotDq3wYV8f=v3Py65xn5ccg6KU2gXbw@mail.gmail.com>
	<87k4b6kt9e.fsf@devron.myhome.or.jp>
	<CAKYAXd-KftOw-YMoA82-75Yp6FNYAXmna+5Fxe0JCMmUB3+-bg@mail.gmail.com>
Date: Tue, 26 Jul 2011 07:32:01 +0900
Message-ID: <CAKYAXd80-cs0iM3h968Gh8MqwPgudrH6ihs_L9oaV=EuDNPevw@mail.gmail.com>
Subject: Re: FAT : FAT16 support maximum 4GB file/vol size like WinXP or 7.
From: NamJae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

And after modifing 0xffffffff, I confirm that it is working well such
as copying file of over 2GB size, etc..

Thanks

2011/7/26 NamJae Jeon <linkinjeon@gmail.com>:
> Hi.
>
> 2011/7/26 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
>> NamJae Jeon <linkinjeon@gmail.com> writes:
>>
>>> Hello Hirofumi
>>>
>>> Win NT/XP/7 increased the maximum cluster size to 64KB, and file/vol
>>> size increased 4GB also.
>>>
>>> Although increasing , the file size of  linux FAT is still limited at 2GB.
>>>
>>> I found that it is limited by sb->s_maxbytes(0x7fffffff) when
>>> partition is formatted by FAT16.
>>
>> Yes. Now, only FAT32 allows it.
>>
>>> I think that sb->s_maxbytes in fill_super should be set to 0xffffffff
>>> like Fat32.
>>>
>>> I want to know your opinion.
>>
>> In my knowledge, Windows was limiting it as 2GB intentionally for
>> compatibility reason.
>>
>> If Windows changed mind, I think it's good that we allow it too for 64KB
>> cluster. BTW, you can select FAT16 with 64KB on Windows?
>>
> Yes, I can select FAT16 with 64KB cluster size on Windows when
> formatting usb storage of 4GB size.
>
> Thanks
>> Thanks.
>> --
>> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>>
>
