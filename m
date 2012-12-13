Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab2LMCKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:10:34 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42240 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab2LMCKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:10:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAKYAXd_91tZ=LgaoPWMVkh6KKPKt0ctfsQo9f4FS-gjf8J77eQ@mail.gmail.com>
References: <1349795401-6497-1-git-send-email-linkinjeon@gmail.com>
	<20121018223058.GA19469@quack.suse.cz>
	<CAKYAXd_91tZ=LgaoPWMVkh6KKPKt0ctfsQo9f4FS-gjf8J77eQ@mail.gmail.com>
Date: Thu, 13 Dec 2012 11:10:32 +0900
Message-ID: <CAKYAXd_-z5OSWwwPuJUHqBOKAaayzUy77iEi=JF0v6zGbXroRQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] udf: implement extent caching while reading-writing
 to a file
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Bonggil Bak <bgbak@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/19, Namjae Jeon <linkinjeon@gmail.com>:
> 2012/10/19, Jan Kara <jack@suse.cz>:
>>   Hello,
>>
>> On Wed 10-10-12 00:10:01, Namjae Jeon wrote:
>>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>>
>>> This patch implements extent caching.
>>> Instead of reading metadata everytime from file's starting position,
>>> now we read from the cached extent.
>>> This speeds up the transformation of file logical offsets to
>>> corresponding on-disk blocks.
>>   I have some mostly minor comments to the patch. But when reading the
>> extent code it is just ugly and hard to follow. So I'm thinking how to
>> improve that before making things even harder with the extent cache. So
>> give me a few more days please.
> Hi Jan.
> Okay, I see. Thanks!
>>
Hi Jan.
Sorry for interrupt. I am still waiting for your review.
Would you check extent cache patches ?
Thanks.

>> 								Honza
