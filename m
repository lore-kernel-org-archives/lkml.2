Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab2JCATT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 20:19:19 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58924 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932882Ab2JCATS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 20:19:18 -0400
MIME-Version: 1.0
In-Reply-To: <20121002122157.GU4587@mwanda>
References: <1349178827-29643-1-git-send-email-yamanetoshi@gmail.com>
	<1349178868-29677-1-git-send-email-yamanetoshi@gmail.com>
	<20121002122157.GU4587@mwanda>
Date: Wed, 3 Oct 2012 09:19:16 +0900
Message-ID: <CAOTypNQw4hSt1uZ0373RUURhO2LAqJ+owmA-xNS_tA2NikwZMg@mail.gmail.com>
Subject: Re: [PATCH 2/3] Add parenthesis to macros with complex values in trace.h
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 9:21 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Tue, Oct 02, 2012 at 08:54:28PM +0900, YAMANE Toshiaki wrote:
>> fixed some checkpatch below error.
>> -ERROR: Macros with complex values should be enclosed in parenthesis
>>
>> Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
>> ---
>>  drivers/staging/rts_pstor/trace.h |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/rts_pstor/trace.h b/drivers/staging/rts_pstor/trace.h
>> index 740999c..a34493c 100644
>> --- a/drivers/staging/rts_pstor/trace.h
>> +++ b/drivers/staging/rts_pstor/trace.h
>> @@ -78,8 +78,8 @@ do {                                                                                                        \
>>       goto label;                                                                                     \
>>  } while (0)
>>  #else
>> -#define TRACE_RET(chip, ret) return ret
>> -#define TRACE_GOTO(chip, label)      goto label
>> +#define TRACE_RET(chip, ret) return(ret)
>> +#define TRACE_GOTO(chip, label)      goto(label)
>
> This will cause a compile error.
>
> There is no need to do this, checkpatch.pl is wrong here.

I will destroy this patch series.
thanks.


YAMANE Toshiaki
