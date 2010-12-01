Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab0LAMwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 07:52:47 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59066 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab0LAMwq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 07:52:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lfWNTVUnS0Y2ZfhfVZEvlxwXCXw0oszgmrPXHpPhd0XzY+8o9Xw/uiw61+bewwKunb
         qfKBOwwm/n7Am1d2LqyDk4hJ9sj9P/qBgm2KgynnOSlsjfaSbnwqIek4zn6zD13mtN1Y
         VaoVapZ1AFJ6lWQS5uVAJJ3MbtwpZyTpdXV1w=
MIME-Version: 1.0
In-Reply-To: <87r5e4lab7.fsf@basil.nowhere.org>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com> <87r5e4lab7.fsf@basil.nowhere.org>
From: Hui Zhu <teawater@gmail.com>
Date: Wed, 1 Dec 2010 20:52:16 +0800
Message-ID: <AANLkTimwnKamJ+UBO1CCn9Hb3PWGgFmC1c0iQr_KeyzO@mail.gmail.com>
Subject: Re: [PATCH] Built kernel without -O2 option
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, gdb@sourceware.org, hellogcc@freelists.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 17:59, Andi Kleen <andi@firstfloor.org> wrote:
> Hui Zhu <teawater@gmail.com> writes:
>
>> Now, there are a lot of ways to debug the Linux kernel with GDB, like
>> qemu, kgtp or kgdb and so on.
>> But the developer more like add a printk. It have a lot of reason, a big one is:
>> (gdb) p ret
>> $3 = <value optimized out>
>> And the code execution order is not right.
>
> Really the right place to fix a lot of this would be gcc (and perhaps
> gdb). I suspect with some careful work the debugging experience
> for -O2 could be improved a lot.
> I also believe the latest gccs already have improvements in this area.
>

If you think they are OK, go get a new gcc and try.  :)

>>
>> This is becuase the Kernel is bult with gcc -O2.  Gcc will not
>> generate enough debug message with file with -O2.
>> So GDB cannot work very well with Linux kernel.
>>
>> So I make a patch that add a option in "Kernel hacking" called "Close
>> GCC optimization".  It will make kernel be built without -O2.
>
>
> You need to at least keep aggressive inlining for header files,
> otherwise there will be too much code bloat and bad code.
>
> Like -O1 -finline-functions ?
>

If I can build OK, why I need add some options?

Thanks,
Hui
