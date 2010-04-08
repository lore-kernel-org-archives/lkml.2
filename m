Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411Ab0DHJzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 05:55:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38505 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758345Ab0DHJzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 05:55:31 -0400
Message-ID: <4BBDA38E.5010801@suse.cz>
Date: Thu, 08 Apr 2010 11:36:14 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.5 Thunderbird/3.0.4
MIME-Version: 1.0
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Jan III Sobieski <jan3sobi3ski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] add random binaries to .gitignore
References: <4BAF4DAF.70609@gmail.com> <20100328133500.GB3622@core2> <4BAF5BD7.1060208@gmail.com> <20100328141957.GA3689@core2> <4BAF618E.2010604@gmail.com> <q2s9c2470ce1004062111hba0a067dwa9705a26d31b47f@mail.gmail.com> <20100407042445.GB3830@cr0.nay.redhat.com>
In-Reply-To: <20100407042445.GB3830@cr0.nay.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7.4.2010 06:24, Amerigo Wang wrote:
> On Wed, Apr 07, 2010 at 06:11:18AM +0200, Jan III Sobieski wrote:
>> Anyone out there care to take this patches?
> 
> I think you need to Cc kbuild people. (Done.)
> 
> This patch looks fine for me, we need this, especially
> the x86 piece, I met it several times.

Added to the kbuild tree, thanks

Michal


>>>
>>> Signed-off-by: Jan III Sobieski <jan3sobi3ski@gmail.com>
>>>
>>> diff --git a/Documentation/filesystems/.gitignore
>>> b/Documentation/filesystems/.gitignore
>>> new file mode 100644
>>> index 0000000..1ddd62a
>>> --- /dev/null
>>> +++ b/Documentation/filesystems/.gitignore
>>> @@ -0,0 +1,2 @@
>>> +dnotify_test
>>> +
>>> diff --git a/Documentation/laptops/.gitignore
>>> b/Documentation/laptops/.gitignore
>>> new file mode 100644
>>> index 0000000..f6bb9d0
>>> --- /dev/null
>>> +++ b/Documentation/laptops/.gitignore
>>> @@ -0,0 +1,2 @@
>>> +dslm
>>> +
>>> diff --git a/Documentation/timers/.gitignore
>>> b/Documentation/timers/.gitignore
>>> new file mode 100644
>>> index 0000000..f710cba
>>> --- /dev/null
>>> +++ b/Documentation/timers/.gitignore
>>> @@ -0,0 +1,2 @@
>>> +hpet_example
>>> +
>>> diff --git a/Documentation/vm/.gitignore b/Documentation/vm/.gitignore
>>> index 09b164a..3c65a46 100644
>>> --- a/Documentation/vm/.gitignore
>>> +++ b/Documentation/vm/.gitignore
>>> @@ -1,2 +1,6 @@
>>>  page-types
>>>  slabinfo
>>> +hugepage-mmap
>>> +hugepage-shm
>>> +map_hugetlb
>>> +
>>> diff --git a/arch/x86/boot/compressed/.gitignore
>>> b/arch/x86/boot/compressed/.gitignore
>>> index 4a46fab..b71c8ca 100644
>>> --- a/arch/x86/boot/compressed/.gitignore
>>> +++ b/arch/x86/boot/compressed/.gitignore
>>> @@ -1,4 +1,5 @@
>>>  relocs
>>> +vmlinux
>>>  vmlinux.bin.all
>>>  vmlinux.relocs
>>>  vmlinux.lds
>>> diff --git a/arch/x86/tools/.gitignore b/arch/x86/tools/.gitignore
>>> new file mode 100644
>>> index 0000000..b1ac2dc
>>> --- /dev/null
>>> +++ b/arch/x86/tools/.gitignore
>>> @@ -0,0 +1,2 @@
>>> +test_get_len
>>> +
