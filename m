Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1FLTfN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 15:35:13 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:41972 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab1FLTfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 15:35:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=M7am6wA0vsVGKfrd42V4q5xHB207V44N5LB4wqncbJU25DtLBeQDyj/kmm8ycpyVnj
         gATeRrnzGijdDxPorMs3LyYpTLs7DtHIzwmbU2I0xje/d7dmPErBlyLRb192T+5KvOBT
         H+K1vf4KNXQFUvPpeM1/sPRuZ+ElrzZEyirGA=
Message-ID: <4DF514BC.9030808@gmail.com>
Date: Sun, 12 Jun 2011 12:34:20 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH]drivers:base:power:trace.c Add "UTC" Coordinated Universal
 Time to the printk.
References: <1307599301-2524-1-git-send-email-justinmattock@gmail.com> <201106121412.09903.rjw@sisk.pl> <4DF4E0CB.4090900@gmail.com> <201106122035.26600.rjw@sisk.pl>
In-Reply-To: <201106122035.26600.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2011 11:35 AM, Rafael J. Wysocki wrote:
> On Sunday, June 12, 2011, Justin P. Mattock wrote:
>> On 06/12/2011 05:12 AM, Rafael J. Wysocki wrote:
>>> Hi,
>>>
>>> On Thursday, June 09, 2011, Justin P. Mattock wrote:
>>>> From: "Justin P. Mattock"<justinmattock@gmail.com>
>>>>
>>>> sounds stupid, but taking a glance at the time, and seeing the wrong time, or what seemed
>>>> wrong in dmesg, caused me to go into total check the time clock panic mode.. So the patch below adds:
>>>> "UTC" Coordinated Universal Time abreviation to the printk so people like me dont flip out over the time!
>>>>
>>>> before:
>>>> [    0.114915] Time:  1:47:03  Date: 06/09/11
>>>>
>>>> after:
>>>> [    0.114728] Time:  5:46:02 UTC Date: 06/09/11
>>>>
>>>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>>
>>> I suspect the goal is to mark messages printed by the PM trace code so that
>>> they can be easily distinguished from messages from other sources to avoid
>>> confusion.  Why do you think it's a good idea to use the "UTC" string for
>>> this purpose?  The time printed in those messages need not be UTC.
>>>
>>> It would be better to simply print "RTC time: ..., date: ..." IMO.
>>>
>>> Thanks,
>>> Rafael
>>>
>>
>> well.. if thats better, then thats better.. over here(people that dont
>> know what RTC time is) would not get so confused with a simple UTC or
>> PDT or whatever the time zone is but if RTC is bettr, then its better.
>
> My point is we don't know this time is always UTC, so we rather shouldn't
> label it as UTC unconditionally, should we?
>
> Rafael
>

sounds good to me!!
