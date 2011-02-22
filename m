Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab1BVFoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 00:44:01 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60200 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab1BVFn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 00:43:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z4hEhzjfyY1IP+dU2BwzUI8zmSGxXSywucykU5LmgSIje35Bz1ww8BFcft91NLPhOq
         b9Of75giYYOMQ9xp3DibyUZlvm5O7/weeTDwgJ+sESck+tX6TGj1olqKWJr8ThRfkJz3
         O6lvMJX8S26PwZFs4TKkP0+bDNtl75NcX+kYs=
MIME-Version: 1.0
In-Reply-To: <20110221125555.4a47424d.rdunlap@xenotime.net>
References: <4D6095E3.2040103@parallels.com>
	<20110221185205.GA23284@mako-laptop>
	<4D62C43F.5040302@parallels.com>
	<20110221120303.48106f6c.rdunlap@xenotime.net>
	<4D62CC6B.9070408@parallels.com>
	<20110221125555.4a47424d.rdunlap@xenotime.net>
Date: Tue, 22 Feb 2011 13:43:58 +0800
Message-ID: <AANLkTi=Uhvz9VfQeXNMH+_-OLp--VdZswAUeU6dz4PQd@mail.gmail.com>
Subject: Re: [PATCH] Remove obsolete Documentation/00-INDEX entries
From: Jovi Zhang <bookjovi@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Rob Landley <rlandley@parallels.com>, Mariusz Kozlowski <mk@lab.zgora.pl>,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 4:55 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Mon, 21 Feb 2011 14:34:51 -0600 Rob Landley wrote:
>
>> On 02/21/2011 02:03 PM, Randy Dunlap wrote:
>> >> I have a http://kernel.org/doc/make/doclinkcheck.py which finds the
>> >> files it lists which don't exist and the files which exist but aren't
>> >> listed.  The current list of files 00-INDEX says exist, but aren't at
>> >> that location, is:
>> >
>> > I'll fix some of these (or accept patches to do so).
>> > Thanks.
>>
>> Let's see...
>>
>> From: Rob Landley <rlandley@parallels.com>
>>
>> Time interpolators were removed in git 1f564ad6d41828
>> Voyager support went away in git b6b6e2b112caf
>>
>> Signed-off-by: Rob Landley <rlandley@parallels.com>
>> ---
>
> Thanks, added to my patch queue.
>
>>
>>  Documentation/00-INDEX |    4 ----
>>  1 file changed, 4 deletions(-)
>>
>> diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
>> index 8dfc670..f607367 100644
>> --- a/Documentation/00-INDEX
>> +++ b/Documentation/00-INDEX
>> @@ -328,8 +328,6 @@ sysrq.txt
>>       - info on the magic SysRq key.
>>  telephony/
>>       - directory with info on telephony (e.g. voice over IP) support.
>> -time_interpolators.txt
>> -     - info on time interpolators.
>>  uml/
>>       - directory with information about User Mode Linux.
>>  unicode.txt
>> @@ -346,8 +344,6 @@ vm/
>>       - directory with info on the Linux vm code.
>>  volatile-considered-harmful.txt
>>       - Why the "volatile" type class should not be used
>> -voyager.txt
>> -     - guide to running Linux on the Voyager architecture.
>>  w1/
>>       - directory with documents regarding the 1-wire (w1) subsystem.
>>  watchdog/
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

There also have many doc located in Documentation directory, but not
in 00-INDEX file, like
apparmor.txt
bad_memory.txt
braille-console.txt
bt8xxgpio.txt
circular-buffers.txt
coccinelle.txt
credentials.txt
debugging-via-ohci1394.txt
devicetree/
dmaengine.txt
dynamic-debug-howto.txt
email-clients.txt
flexible-arrays.txt
futex-requeue-pi.txt
gcov.txt
...

Also there have some entry not list as alphabetical order.
