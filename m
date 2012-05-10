Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab2EJDEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 23:04:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40870 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab2EJDEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 23:04:10 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.02.1205092358090.6376@nyarly>
References: <1336615995-3813-1-git-send-email-zwu.kernel@gmail.com>
	<alpine.LNX.2.02.1205092358090.6376@nyarly>
Date: Thu, 10 May 2012 11:04:09 +0800
Message-ID: <CAEH94LgFJk6_yXWbQwvFDvN2HL=qnWbB5gmC5ZwE0heygZWX8w@mail.gmail.com>
Subject: Re: [PATCH] block: remove some unnecessary codes
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Thiago Rafel Becker <trbecker@trbecker.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, wuzhy@linux.vnet.ibm.com,
        stefanha@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 10:58 AM, Thiago Rafel Becker
<trbecker@trbecker.org> wrote:
> You should also remove the if statement on line 511.
Yeah, good comment. thanks. pls see v2.
>
> On Thu, 10 May 2012, zwu.kernel@gmail.com wrote:
>
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> ---
>>  block/partition-generic.c |    2 --
>>  1 files changed, 0 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/partition-generic.c b/block/partition-generic.c
>> index 6df5d69..4c03880 100644
>> --- a/block/partition-generic.c
>> +++ b/block/partition-generic.c
>> @@ -473,7 +473,6 @@ rescan:
>>       /* add partitions */
>>       for (p = 1; p < state->limit; p++) {
>>               sector_t size, from;
>> -             struct partition_meta_info *info = NULL;
>>
>>               size = state->parts[p].size;
>>               if (!size)
>> @@ -509,7 +508,6 @@ rescan:
>>               }
>>
>>               if (state->parts[p].has_info)
>> -                     info = &state->parts[p].info;
>>               part = add_partition(disk, p, from, size,
>>                                    state->parts[p].flags,
>>                                    &state->parts[p].info);
>> --
>> 1.7.6
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>



-- 
Regards,

Zhi Yong Wu
