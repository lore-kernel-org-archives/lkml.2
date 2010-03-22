Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab0CVJ5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 05:57:45 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:54876 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab0CVJ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 05:57:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=vM7vqDc+R2Ckj/K2+7hIPNQ+Mex3MulhxjpNcT9U7EuGbS/3QzgSk779mOrPhRfqwb
         rIVBr++r0Sa7kn6PtzWoJBv9tZoSE+nbfewm/4mwz3bdBKQM7JY6hNqI9Ge//bKBP80z
         22aeMqeIm25hHU7nyTr7cbHmCmBW2OKDPC0uI=
MIME-Version: 1.0
In-Reply-To: <4BA73C4C.4020708@coyote.org>
References: <1269210658-9518-1-git-send-email-lindley@coyote.org>
	 <4BA71949.9040809@cs.helsinki.fi> <4BA73C4C.4020708@coyote.org>
Date: Mon, 22 Mar 2010 11:57:42 +0200
X-Google-Sender-Auth: d55df291a451398e
Message-ID: <84144f021003220257k1bd88315x3eb21057b4696a8f@mail.gmail.com>
Subject: Re: [PATCH] staging: winbond: wb35reg_f.h Coding style fixes.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, pavel@ucw.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 11:45 AM, Lars Lindley <lindley@coyote.org> wrote:
> On 2010-03-22 08:16, Pekka Enberg wrote:
>> Lars Lindley kirjoitti:
>>> I fixed the checkpatch things except a couple of long lines.
>>> I also removed hungarian notation from the argument names
>>> and some "commented away" code.
>>>
>>> Signed-off-by: Lars Lindley <lindley@coyote.org>
>>
>> Did you check that all these function declarations are actually used?
>> I've spotted plenty of dead code in the past.
>>
> Nope, didn't check that. Just looking at the style now..

Well, based on my experience, you're will do a lot of unnecessary work
on code that's going to get removed because it's not actually used.
That's why I haven't bothered with style cleanups much.

>>> +/*
>>> + * ====================================
>>> + * Interface function declare
>>> + * ====================================
>>> + */
>>> +unsigned char Wb35Reg_initial(struct hw_data *HwData);
>>
>> Lets avoid CamelCase for the arguments so "hw_data" here, for example. I
>> see the same thing elsewhere in this patch as well.
>>
> I thought struct hw_data *hw_data looked a bit confusing..Thats why I left
> CamelCase alone for now. I can make it like that if you want..

Yes please.
