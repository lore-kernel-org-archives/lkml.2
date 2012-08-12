Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab2HLLCC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 07:02:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45231 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab2HLLCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 07:02:00 -0400
Message-ID: <50278D23.3000008@gmail.com>
Date: Sun, 12 Aug 2012 21:01:55 +1000
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] Fat checkstyle patch set (1)
References: <1344764687-4155-1-git-send-email-cruzjbishop@gmail.com> <877gt4behg.fsf@devron.myhome.or.jp>
In-Reply-To: <877gt4behg.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/12 20:18, OGAWA Hirofumi wrote:
> Cruz Julian Bishop <cruzjbishop@gmail.com> writes:
>
>> Hi (and to the mailing list, again).
>>
>> This is a patch series that fixes checkpatch issues in fs/fat.
>>
>> I didn't get to do all of the files, but I'll be sure to come back for
>> them later :)
>>
>> Please let me know if I did something wrong - I'll be sure to take it on
>> for my next patches.
> Is this for -mm tree? Please make sure there is no conflict. 
It's actually based on -next, but I think that's taken over what -mm
was doing in the past, anyway.
>
> Yeah, small patch is preferred, but it should be the logical separation,
> and one patch would be better in this case, IMHO.
>
> Personally, I'm not against this type cleanup only if there is no
> conflict though (i.e. doesn't increase maintain cost). So, if akpm is
> fine to take this, then I'm ok.
Thank you - I'll remember that in the future
>
>> Cruz Julian Bishop (7):
>>   fs/fat: Fix a checkpatch issue in namei_msdos.c
>>   fs/fat: Fix some checkpatch issues in fat.h
>>   fs/fat: Changed indentation of some comments in fat.h
>>   fs/fat: Fix two checkstyle issues in cache.c
>>   fs/fat: Fixes some small checkpatch issues is dir.c
>>   fs/fat: Fix all other checkstyle issues in dir.c
>>   fs/fat: Fix checkpatch issues in fatent.c
> There was one strange new line in a patch. Otherwise,
>
> Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Again, thank you :)

