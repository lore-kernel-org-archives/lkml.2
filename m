Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab0I2M5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:57:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49730 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab0I2M5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:57:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NKtMLyssLHLVfb+Y8PW3QJMifHaI5CcvSsGbw71fsdc282PmDqoo0kmiOzzDJbZyUn
         0PbFpM9gIht1oHpZw9bV+UkzlRHPLOJNaimRJldKBb1pza3AgeZsRKyK+rPLDwsWvLZl
         hJ+S0HX6Pn/HQh8OTXjcZpf6T7jxdkLEKQwww=
MIME-Version: 1.0
In-Reply-To: <201009291419.39832.arnd@arndb.de>
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
	<AANLkTimFbxc7MGdirSzdJ-YZbFFHBVn4JJhHcP46W1_4@mail.gmail.com>
	<20100928174459.53c5a865.akpm@linux-foundation.org>
	<201009291419.39832.arnd@arndb.de>
Date: Wed, 29 Sep 2010 14:57:43 +0200
Message-ID: <AANLkTi=ObLV_BWvjhdJZK5NA0x9zdtvKSRU3_NV94zvG@mail.gmail.com>
Subject: Re: mmotm 2010-09-28-16-13 uploaded
From: "N.P.S. N.P.S." <napohybelskurwysynom2010@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/29 Arnd Bergmann <arnd@arndb.de>:
> On Wednesday 29 September 2010, Andrew Morton wrote:
>> On Wed, 29 Sep 2010 02:27:55 +0200 "N.P.S. N.P.S." <napohybelskurwysynom2010@gmail.com> wrote:
>> > Was there any contest for function, which will cause many warnings?
>> >
>> > I'm getting an awful lot of
>> >   CC      kernel/trace/trace_sched_switch.o
>> > In file included from kernel/trace/trace_sched_switch.c:8:
>> > include/linux/fs.h:1278: warning: function declaration isn___t a prototype
>> > include/linux/fs.h:1282: warning: function declaration isn___t a prototype
>> >   CC      kernel/trace/trace_functions.o
>> > In file included from include/linux/debugfs.h:18,
>> >                  from kernel/trace/trace_functions.c:13:
>> > include/linux/fs.h:1278: warning: function declaration isn___t a prototype
>> > include/linux/fs.h:1282: warning: function declaration isn___t a prototype
>>
>> Arnd has been bad.
>
> Sorry about that, I obviously forgot to test without CONFIG_FILE_LOCKING.
> Are you actually using that configuration, or did you find it during
> random build testing?

It was randconfig build.

>
>> commit 0a4de5980db88de75b798b291524ba9af8553e7c
>> Author:     Arnd Bergmann <arnd@arndb.de>
>> AuthorDate: Sat Sep 18 15:09:31 2010 +0200
>> Commit:     Arnd Bergmann <arnd@arndb.de>
>> CommitDate: Sat Sep 25 18:07:47 2010 +0200
>>
>>     fs/locks.c: prepare for BKL removal
>
> I updated that commit now.

Thanks

>
>        Arnd
>



-- 
Slawa!
N.P.S.
