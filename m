Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab2JCASm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 20:18:42 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48729 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932882Ab2JCASl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 20:18:41 -0400
MIME-Version: 1.0
In-Reply-To: <1349179923.13371.186.camel@smile>
References: <1349178827-29643-1-git-send-email-yamanetoshi@gmail.com>
	<1349179923.13371.186.camel@smile>
Date: Wed, 3 Oct 2012 09:18:39 +0900
Message-ID: <CAOTypNRU8WODGkgsjs-kEAxcX8adZrvTTC4b27oWV2PL3q-Nxg@mail.gmail.com>
Subject: Re: [PATCH 1/3] Fix trailing whitespace in trace.h
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 9:12 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Tue, 2012-10-02 at 20:53 +0900, YAMANE Toshiaki wrote:
>> fixed below checkpatch error.
>>
>> -ERROR: trailing whitespace
>>
>> Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
>> ---
>>  drivers/staging/rts_pstor/trace.h |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/rts_pstor/trace.h b/drivers/staging/rts_pstor/trace.h
>> index cf60a1b..740999c 100644
>> --- a/drivers/staging/rts_pstor/trace.h
>> +++ b/drivers/staging/rts_pstor/trace.h
>> @@ -39,7 +39,7 @@ static inline char *filename(char *path)
>>       while (*ptr != '\0') {
>>               if ((*ptr == '\\') || (*ptr == '/'))
>>                       path = ptr + 1;
>> -
>> +
>>               ptr++;
>>       }
>
> For me it seems total filename() function could be squeezed to just strrchr(path, '/') + 1;
> Moreover there is already basename() in the lib/dynamic_debug.c you
> could rename, export and reuse.

I will destroy this patch series.
thanks.


YAMANE Toshiaki
