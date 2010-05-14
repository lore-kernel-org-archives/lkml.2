Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab0ENA3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:29:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51367 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab0ENA3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:29:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=S3Lwne0hTHRX3t5tJhblxh5DgKD5mSSn+k/Gqx8YLyXd4+cKkietSWLFR/+PP64qIK
         Hc/yhtgBtpHAgdkH79aiy399LJ0fyZ7+Qqfd2sxPb1aAemCrv6898rM66JOVv7PGYBCf
         SKmDv1q+T+Qoe0sgbNf3j2waQA+LTU9duE/7s=
MIME-Version: 1.0
In-Reply-To: <4BEC9782.2040705@gmail.com>
References: <4BEC7A84.3010503@gmail.com> <AANLkTim7B5z76zJ33by6SGMgSy1gZF6qiwhEhAQ3NUtG@mail.gmail.com> 
	<4BEC9782.2040705@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 13 May 2010 17:28:49 -0700
X-Google-Sender-Auth: pIINQoIvIlD5hAyEP0du2G8QtAc
Message-ID: <AANLkTinKoMxdkPYQA_AblpByL6zAiAP5hv2M3Jn2R3hM@mail.gmail.com>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 5:21 PM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> On 05/13/10 16:01, Luis R. Rodriguez wrote:
>>
>> On Thu, May 13, 2010 at 3:17 PM, Justin P. Mattock
>> <justinmattock@gmail.com>  wrote:
>>>
>>> not sure what this is, but while at a convention
>>> I was trying to access the internet and(below is
>>> full dmesg) this showed up.
>>>
>>> After receiving this, I sat and tried to re-create
>>> my steps to reproduce but had no luck(was even going
>>> todo a bisect n the spot if I could re-create).
>>
>> OK this stuff is hard to reproduce it seems.. you have an Atheros
>> AR5418 MAC/BB Rev:2 AR5133 RF Rev:81, what kconfig option do you use
>> to get the poison stuff? I am just surprised we haven't seen it
>> ourselves yet. Let me make sure all of us get this kconfig option
>> enabled.
>>
>>   Luis
>>
>
>
>
> CONFIG_ATH_COMMON=m
> # CONFIG_ATH_DEBUG is not set
> CONFIG_ATH5K=m
> # CONFIG_ATH5K_DEBUG is not set
> CONFIG_ATH9K_HW=m
> CONFIG_ATH9K_COMMON=m
> CONFIG_ATH9K=m
> # CONFIG_ATH9K_DEBUGFS is not set
>
> if you need my .config let me know.
> (I can try again reproducing, but man
> just doesn't easily fire off).

Oh I mean the config options to enable the poison rant.

  Luis
