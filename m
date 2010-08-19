Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab0HSN0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 09:26:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44531 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab0HSN0c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 09:26:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AKwdbtfGbeNK+jmBH5FW5LRjqQdqYZ7AFjYk0R7jVIduN6dTFuX7VJP0P8Mffq7y47
         en1I2IhLV5c6dg4522hgp6F+7E5vYIv/rGsdJ5NaiMjqKGevHnz9E4v0Z4UVs1yngtol
         1AhDQElwPv0O/nbf6/GOIU/yPhqLtwCpuZSwU=
MIME-Version: 1.0
In-Reply-To: <AANLkTinjKK_jKm04BNmTRwq5uW8ainDcJHOXCGCmOXuD@mail.gmail.com>
References: <20100818151857.GA6188@barrios-desktop>
	<20100818172627.7e38969f@varda>
	<AANLkTimxbJQ7+cJ20x1Bcm=1xk_JgMANUQDFn-pJ9jZa@mail.gmail.com>
	<AANLkTimqzQHtSo5f41ze4JEznGCjMNTC_1DPgc21JYT0@mail.gmail.com>
	<AANLkTinjKK_jKm04BNmTRwq5uW8ainDcJHOXCGCmOXuD@mail.gmail.com>
Date: Thu, 19 Aug 2010 10:53:45 +0900
Message-ID: <AANLkTingyhdHQUF4zp-xr_RMD1AJTid6m4kMUuOEH9M3@mail.gmail.com>
Subject: Re: android-kernel memory reclaim x20 boost?
From: Minchan Kim <minchan.kim@gmail.com>
To: San Mehat <san@google.com>
Cc: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        =?ISO-8859-1?Q?Alejandro_Riveira_Fern=E1ndez?= <ariveira@gmail.com>,
        swetland@google.com, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 10:04 AM, San Mehat <san@google.com> wrote:
> On Wed, Aug 18, 2010 at 6:01 PM, Arve Hjønnevåg <arve@android.com> wrote:
>> On Wed, Aug 18, 2010 at 5:54 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
>>> On Thu, Aug 19, 2010 at 12:26 AM, Alejandro Riveira Fernández
>>> <ariveira@gmail.com> wrote:
>>>> El Thu, 19 Aug 2010 00:18:57 +0900
>>>> Minchan Kim <minchan.kim@gmail.com> escribió:
>>>>
>>>>> Hello Android forks,
>>>> [ ... ]
>>>>>
>>>>> I saw the advertisement phrase in this[1].
>>>>>
>>>>> "Kernel Memory Management Boost: Improved memory reclaim by up to 20x,
>>>>> which results in faster app switching and smoother performance
>>>>> on memory-constrained devices."
>>>>>
>>>>> But I can't find any code for it in android kernel git tree.
>>>>
>>>>  Maybe the enhancements are on the Dalvik VM (shooting in the dark here)
>>>
>>> Thanks.
>>> Android guys! Could you confirm this?
>>>
>>
>> It is more likely referring to this change:
>>
>
> There are other changes after the one mentioned that remove the
> requirement for CONFIG_PROFILING
> (and the subsequent task_struct leak that was caused by it)
>
> -san

It seems to be not a issue of mainline but only one of android lowmemkiller.
Thanks for the information, Android forks.


-- 
Kind regards,
Minchan Kim
