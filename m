Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab0FNCyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 22:54:17 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37392 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab0FNCyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 22:54:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kj+3P+N2Fm/UZP3TffI6fDr3uQfJXz53L7Wn4ghPx6C8qiSuyibPJosFGU09+QVGPC
         CFCqFWwyILkVxhr+fyedzzKVR/YI1vU/lElPhgiY4tDKFOeCS4Vn/0zeA9Bay0KwnPtU
         IAynN3u+zckPJhUgkq66nzfuZfZaIx46Ihtfg=
Message-ID: <4C1599E4.4080703@gmail.com>
Date: Sun, 13 Jun 2010 19:54:28 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: warning from gcc version 4.6.0 20100416
References: <4C11A598.8090504@gmail.com> <4C158335.9000906@tmr.com>
In-Reply-To: <4C158335.9000906@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2010 06:17 PM, Bill Davidsen wrote:
> Justin P. Mattock wrote:
>> o.k. andi,
>>
>> here is the rest of the warnings that
>> I see when compiling the kernel
>>
>> I can try and create some patches for
>> this(hopefully!!)
>>
> There is no great solution to this, in a fair number of cases the fix
> would slow the code or make it harder to read, so some of these probably
> don't want a fix. Of course some clearly are errors, so you are doing
> something valuable by checking.
>>

cool thanks..
I'm guessing lots
of false positives then.
I'll go through and see what
I find..

Justin P. Mattock
