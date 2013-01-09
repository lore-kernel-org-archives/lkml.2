Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab3AIG0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 01:26:45 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:44280 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757126Ab3AIG0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 01:26:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAKYAXd_-z5OSWwwPuJUHqBOKAaayzUy77iEi=JF0v6zGbXroRQ@mail.gmail.com>
References: <1349795401-6497-1-git-send-email-linkinjeon@gmail.com>
	<20121018223058.GA19469@quack.suse.cz>
	<CAKYAXd_91tZ=LgaoPWMVkh6KKPKt0ctfsQo9f4FS-gjf8J77eQ@mail.gmail.com>
	<CAKYAXd_-z5OSWwwPuJUHqBOKAaayzUy77iEi=JF0v6zGbXroRQ@mail.gmail.com>
Date: Wed, 9 Jan 2013 15:26:43 +0900
Message-ID: <CAKYAXd-Mm72cGwAoYd1ZtMFXD8WF2E3u7S23zckhoFA=h+4XhA@mail.gmail.com>
Subject: Re: [PATCH 5/6] udf: implement extent caching while reading-writing
 to a file
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/13, Namjae Jeon <linkinjeon@gmail.com>:
> 2012/10/19, Namjae Jeon <linkinjeon@gmail.com>:
>> 2012/10/19, Jan Kara <jack@suse.cz>:
>>>   Hello,
>>>
>>> On Wed 10-10-12 00:10:01, Namjae Jeon wrote:
>>>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>>>
>>>> This patch implements extent caching.
>>>> Instead of reading metadata everytime from file's starting position,
>>>> now we read from the cached extent.
>>>> This speeds up the transformation of file logical offsets to
>>>> corresponding on-disk blocks.
>>>   I have some mostly minor comments to the patch. But when reading the
>>> extent code it is just ugly and hard to follow. So I'm thinking how to
>>> improve that before making things even harder with the extent cache. So
>>> give me a few more days please.
>> Hi Jan.
>> Okay, I see. Thanks!
>>>
> Hi Jan.
> Sorry for interrupt. I am still waiting for your review.
> Would you check extent cache patches ?
> Thanks.
Hi Jan.

Maybe You think you didn't convince extent cache implementation of
write part in this patch.
So I suggest that once, we add extent cache of read part first in case
of read-only mount type.
because it is real issue on 3D BD-disk playing(BD Disk is used on
read-only mount type).
And I will check more write part again.

Thanks.

>
>>> 								Honza
>
