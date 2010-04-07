Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab0DGELZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 00:11:25 -0400
Received: from mail-ew0-f222.google.com ([209.85.219.222]:39844 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab0DGELT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 00:11:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=lLhjIbcXFsOPVQxVSq9V2ZqR6pmoGTFBYmqP4kJkAUjKGaeSwny1dsachjcIerLGtk
         xEo9DBR2oyms4LWVSydEvbBquMrDoqVqtNgFvUg4HVYhrelNnMOlDtgjgmbzdW/TD60f
         P1OxyHg3WfFbddHLK0EUJi2A6CZI0BKOMQPB4=
MIME-Version: 1.0
In-Reply-To: <4BAF618E.2010604@gmail.com>
References: <4BAF4DAF.70609@gmail.com> <20100328133500.GB3622@core2>
	 <4BAF5BD7.1060208@gmail.com> <20100328141957.GA3689@core2>
	 <4BAF618E.2010604@gmail.com>
Date: Wed, 7 Apr 2010 06:11:18 +0200
Message-ID: <q2s9c2470ce1004062111hba0a067dwa9705a26d31b47f@mail.gmail.com>
Subject: Re: [PATCH] add random binaries to .gitignore
From: Jan III Sobieski <jan3sobi3ski@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/28 Jan III Sobieski <jan3sobi3ski@gmail.com>:
> W dniu 2010-03-28 16:19, Alexey Dobriyan pisze:
>> On Sun, Mar 28, 2010 at 03:38:31PM +0200, Jan III Sobieski wrote:
>>> W dniu 2010-03-28 15:35, Alexey Dobriyan pisze:
>>>> On Sun, Mar 28, 2010 at 02:38:07PM +0200, Jan III Sobieski wrote:
>>>>> +# random binary files
>>>>> +Documentation/filesystems/dnotify_test
>>>>> +Documentation/laptops/dslm
>>>>> +Documentation/timers/hpet_example
>>>>> +Documentation/vm/hugepage-mmap
>>>>> +Documentation/vm/hugepage-shm
>>>>> +Documentation/vm/map_hugetlb
>>>>> +arch/x86/boot/compressed/vmlinux
>>>>> +arch/x86/tools/test_get_len
>>>>
>>>> This should go to per-directory gitiignores.
>>>
>>> I agree that it is not the best solution. But one directory one
>>> .gitignore also isn't the best, so I propose this
>>
>> .gitignore in leaf directory is the status quo.
>>
>>       find . -type f -name '\.gitignore'
>
> Ok

Anyone out there care to take this patches?

>
> --
> Jan III Sobieski
>
> Signed-off-by: Jan III Sobieski <jan3sobi3ski@gmail.com>
>
> diff --git a/Documentation/filesystems/.gitignore
> b/Documentation/filesystems/.gitignore
> new file mode 100644
> index 0000000..1ddd62a
> --- /dev/null
> +++ b/Documentation/filesystems/.gitignore
> @@ -0,0 +1,2 @@
> +dnotify_test
> +
> diff --git a/Documentation/laptops/.gitignore
> b/Documentation/laptops/.gitignore
> new file mode 100644
> index 0000000..f6bb9d0
> --- /dev/null
> +++ b/Documentation/laptops/.gitignore
> @@ -0,0 +1,2 @@
> +dslm
> +
> diff --git a/Documentation/timers/.gitignore
> b/Documentation/timers/.gitignore
> new file mode 100644
> index 0000000..f710cba
> --- /dev/null
> +++ b/Documentation/timers/.gitignore
> @@ -0,0 +1,2 @@
> +hpet_example
> +
> diff --git a/Documentation/vm/.gitignore b/Documentation/vm/.gitignore
> index 09b164a..3c65a46 100644
> --- a/Documentation/vm/.gitignore
> +++ b/Documentation/vm/.gitignore
> @@ -1,2 +1,6 @@
>  page-types
>  slabinfo
> +hugepage-mmap
> +hugepage-shm
> +map_hugetlb
> +
> diff --git a/arch/x86/boot/compressed/.gitignore
> b/arch/x86/boot/compressed/.gitignore
> index 4a46fab..b71c8ca 100644
> --- a/arch/x86/boot/compressed/.gitignore
> +++ b/arch/x86/boot/compressed/.gitignore
> @@ -1,4 +1,5 @@
>  relocs
> +vmlinux
>  vmlinux.bin.all
>  vmlinux.relocs
>  vmlinux.lds
> diff --git a/arch/x86/tools/.gitignore b/arch/x86/tools/.gitignore
> new file mode 100644
> index 0000000..b1ac2dc
> --- /dev/null
> +++ b/arch/x86/tools/.gitignore
> @@ -0,0 +1,2 @@
> +test_get_len
> +
>



-- 
Jan III Sobieski
