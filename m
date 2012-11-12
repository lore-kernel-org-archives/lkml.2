Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab2KLJMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 04:12:43 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34630 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2KLJMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 04:12:41 -0500
MIME-Version: 1.0
In-Reply-To: <87obj35k3a.fsf@devron.myhome.or.jp>
References: <1352642278-2730-1-git-send-email-linkinjeon@gmail.com>
	<874nkw86jz.fsf@devron.myhome.or.jp>
	<CAKYAXd_HBP1ToGunoPwut18v+hwdG=QdfeXyJVSrLUGEt6beSQ@mail.gmail.com>
	<87sj8f5k4m.fsf@devron.myhome.or.jp>
	<87obj35k3a.fsf@devron.myhome.or.jp>
Date: Mon, 12 Nov 2012 18:12:39 +0900
Message-ID: <CAKYAXd_=wCLo5RZhOaur7Yjw+6MYk-DhRPTjy148Yo0z6z9BcQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] fat: fix time updates for create and delete
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/12, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
>
>> Namjae Jeon <linkinjeon@gmail.com> writes:
>>
>>> 2012/11/12, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
>>>> Namjae Jeon <linkinjeon@gmail.com> writes:
>>>>
>>>>> Correctly update modification and status change time in case of
>>>>> file/directory removal and creation.
>>>>
>>>> This changelog just explain "what", and it doesn't explain "why".
>>>> Please
>>>> explain why we need this change.
>>>>
>>>> IIRC, timestamp handling in FAT driver is strange historically. Anyway,
>>>> FAT doesn't have "inode change time". It is "creation time" in FAT.
>>> Hi. OGAWA.
>>> I made this patch after comparing timestamp handlings with MSDOS and
>>> XFS.
>>> Should timestamp handling of FAT be same with MSDOS ?
>>> Am I missing ?
>>
>> What was difference with XFS, FAT, and MSDOS?
Okay, the description of patch was lacked, So I will resend patch with
specifical test reseult with other filesystem.
>
> BTW, I recall I checked this, and yes, it is strange. But it is historical.
"historical" means It is difficult to change ?

Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
