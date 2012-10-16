Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab2JPCnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 22:43:18 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42642 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab2JPCnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 22:43:16 -0400
Message-ID: <507CC9BB.2020007@lwfinger.net>
Date: Mon, 15 Oct 2012 21:43:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/version.h: Update for kernel 3.7
References: <507c837f.D1Nk8uFiYhA4dhxy%Larry.Finger@lwfinger.net> <20121015215411.GB28086@liondog.tnic>
In-Reply-To: <20121015215411.GB28086@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2012 04:54 PM, Borislav Petkov wrote:
> On Mon, Oct 15, 2012 at 04:43:27PM -0500, Larry Finger wrote:
>> The value for LINUX_VERSION_CODE was not updated for kernel 3.7-rc1.
>
> That's probably fallout from the whole UAPI thing.
>
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>   version.h |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>> ---
>>
>> Index: linux-2.6/include/linux/version.h
>> ===================================================================
>> --- linux-2.6.orig/include/linux/version.h
>> +++ linux-2.6/include/linux/version.h
>> @@ -1,2 +1,2 @@
>
> There are two version.h files on my box:
>
>> -#define LINUX_VERSION_CODE 198144
>
> This is in <include/linux/version.h>
>
>> +#define LINUX_VERSION_CODE 198400
>
> This is in <include/generated/uapi/linux/version.h>
>
> I'd guess that everything should include this new version.h file now
> since the Makefile generates this now and not the one above.
>
> But I could very well be wrong.

It seems to be fixed now.

Thanks,

Larry


