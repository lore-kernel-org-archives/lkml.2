Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab0FIIOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 04:14:45 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43714 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab0FIIOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 04:14:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IuIVkNhM03AqiS5cSGtKndG7R468dn6UkGGYEMKcL7lwDUbXNKyA53llayMQ+Es7iF
         Zva5efP00hqGCGO+Wrs3cTiInTaI+QKQG3eVYxP/wVGhm65K5gzkGhu0qKPoR2csY70R
         pTb8GxguuvvKNp26iLFuKOu3O4YueFDyQv9+s=
MIME-Version: 1.0
In-Reply-To: <AANLkTik4kdjh1Wmo704_3-jzxmMUd8vGce9Mdojveml1@mail.gmail.com>
References: <AANLkTik0UvRGmGeZOMaJVaoHk-lv2V8umAF3EIckh9CT@mail.gmail.com>
	<1276051329.13426.48.camel@localhost.localdomain>
	<AANLkTikSaMcKPh5GI3Tq2SZkVXsNKwE8pfR8me5IHDDv@mail.gmail.com>
	<AANLkTik4kdjh1Wmo704_3-jzxmMUd8vGce9Mdojveml1@mail.gmail.com>
Date: Wed, 9 Jun 2010 16:14:42 +0800
Message-ID: <AANLkTimkJjZ32kIl4rjikZqBrFCFPw0zCS7b9uh6gO2V@mail.gmail.com>
Subject: Re: When and how to use ftrace?
From: Ryan Wang <openspace.wang@gmail.com>
To: Neependra Khare <neependra.khare@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
       kernelnewbies@nl.linux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/9 Neependra Khare <neependra.khare@gmail.com>:
>
>
> On Wed, Jun 9, 2010 at 11:02 AM, Ryan Wang <openspace.wang@gmail.com> wrote:
>>
>> I really want to know is the differences between ftrace and other kernel
>> debug
>> tools such as kdump, kdb, etc.
>
> Lets say you want to know what ext2/ext3/ext4 functions are called when you
> run mkdir command on ext2/ext3/ext4 mounted filesystem. Then you can trace
> each kernel function with ftrace.
>
> Articles on ftrace:-
> http://lwn.net/Articles/365835/
> http://lwn.net/Articles/366796/
>
> With kdump you get memory dump of currently running kernel and then you
> debug it.
> kdb will help you to debug the currently running kernel.
>
> I hope this clears some of your doubts.
>
> Regards,
> Neependra
>
>>
>> thanks!
>>
>> --
>> To unsubscribe from this list: send an email with
>> "unsubscribe kernelnewbies" to ecartis@nl.linux.org
>> Please read the FAQ at http://kernelnewbies.org/FAQ
>>
>
>

Seems ftrace is helpful to study the activities inside the kernel to me.
I wonder whether it can be useful to debug kernel bugs. And if so, will
you please give me some examples? Or so far it's mainly used for
observing the running status of kernel?

thanks,
