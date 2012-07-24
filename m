Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2GXDhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 23:37:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59220 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab2GXDhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 23:37:54 -0400
Message-ID: <500E188E.2020805@gmail.com>
Date: Mon, 23 Jul 2012 20:37:50 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
CC: gregkh@linuxfoundation.org, vjaquez@igalia.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH NEXT]staging "tidspbridge" Fix typos.
References: <1343051366-26282-1-git-send-email-justinmattock@gmail.com> <CAB-zwWjCEprbEGJ5f3HoyHhZPTaMUramZk=YG=1b63U-pGymQA@mail.gmail.com>
In-Reply-To: <CAB-zwWjCEprbEGJ5f3HoyHhZPTaMUramZk=YG=1b63U-pGymQA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2012 01:44 PM, Ramirez Luna, Omar wrote:
> Hi Justin,
>
> On Mon, Jul 23, 2012 at 8:49 AM, Justin P. Mattock
> <justinmattock@gmail.com> wrote:
>> diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
>> index f9609ce..2c82d5a 100644
>> --- a/drivers/staging/tidspbridge/core/tiomap3430.c
>> +++ b/drivers/staging/tidspbridge/core/tiomap3430.c
>> @@ -328,7 +328,7 @@ static int bridge_brd_read(struct bridge_dev_context *dev_ctxt,
>>                                             ul_num_bytes, mem_type);
>>                  return status;
>>          }
>> -       /* copy the data from  DSP memory, */
>> +       /* copy the data from DSP memory, */
>
> I guess we can get rid of the comma (,) at the end of this sentence.

good catch!

>
> ...
>> diff --git a/drivers/staging/tidspbridge/include/dspbridge/proc.h b/drivers/staging/tidspbridge/include/dspbridge/proc.h
>> index a82380e..9cd5022 100644
>> --- a/drivers/staging/tidspbridge/include/dspbridge/proc.h
>> +++ b/drivers/staging/tidspbridge/include/dspbridge/proc.h
>> @@ -263,7 +263,7 @@ extern int proc_get_processor_id(void *proc, u32 * proc_id);
>>    *  Returns:
>>    *      0     :   Success.
>>    *      -EFAULT :   Invalid processor handle.
>> - *      -EPERM   :   General failure while retireving processor trace
>> + *      -EPERM   :   General failure while retireing processor trace
>
> This was meant to be 'retrieving'.
>
> And given that this is focused on tidspbridge, could you change the
> patch subject? To: staging: tidspbridge: fix typos.
>
> Cheers,
>
> Omar
>

ah.. I see now.. comments can be tough to decipher sometimes with what 
the writer is saying, helps to know what the code is doing.

cheers, resending the revised version, and Thank you for taking the time.

Justin P. Mattock
