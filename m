Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab1FNSDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:03:25 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:47197 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491Ab1FNSDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:03:24 -0400
X-AuditID: 1209190d-b7bdeae0000004f8-32-4df7a224cae9
Message-ID: <4DF7A264.3030901@mit.edu>
Date: Tue, 14 Jun 2011 14:03:16 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, vsyscall: Fix build warning in vsyscall_64.c
References: <1307777464.25182.3.camel@localhost.localdomain>	<BANLkTi=SQb6EL4+bdH2Q+iwaW9E3i+48Ew@mail.gmail.com>	<BANLkTi=yEo9fcXW8SqUCtSOag7Mn_+Ni9Q@mail.gmail.com>	<BANLkTimv6F8NsH0Lg7q6gi1-oiBv8nUrSA@mail.gmail.com>	<BANLkTikbnsu05+Nae8isATuZ8Fucj14+LQ@mail.gmail.com>	<BANLkTi=nsCK2bFf2v+PkKj=Opsxseqe9pQ@mail.gmail.com>	<BANLkTi=ZETGToRcOHXg5gxAQO3EKN+YyLg@mail.gmail.com> <BANLkTi=-xJizWP5H9vNvaJhRN-Vm-ubraA@mail.gmail.com>
In-Reply-To: <BANLkTi=-xJizWP5H9vNvaJhRN-Vm-ubraA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsUixG6nrquy6LuvweOvQhbTNopbXN41h81i
	y6VmVotNJ34zWmzeNJXZ4seGx6wObB632v4we+ycdZfdY9OqTjaPd+fOsXt83iTncaLlC2sA
	WxSXTUpqTmZZapG+XQJXxopTvawFfyQq1nUuY29gnCnSxcjJISFgIrHvyzFWCFtM4sK99Wxd
	jFwcQgL7GCV+HJ3IBOFsYJR4u+YgM4RzgUli9qfZzCAtvAJqEo9uXwRrZxFQlbh+YCcLiM0m
	oCLRsfQBE4gtKlApMennDlaIekGJkzOfANVwcIgIaEu8/WgHYjILZEusXp8EUiEs4CZxeusK
	NhBbSGA9s8TvqVwgNqeAo8SuPd/ZIMqtJb7tLgIJMwvIS2x/O4d5AqPgLCTzZyFUzUJStYCR
	eRWjbEpulW5uYmZOcWqybnFyYl5eapGukV5uZoleakrpJkZQHHBK8u5gfHdQ6RCjAAejEg/v
	2crvvkKsiWXFlbmHGCU5mJREecUXAoX4kvJTKjMSizPii0pzUosPMUpwMCuJ8Pa++uIrxJuS
	WFmVWpQPk5LmYFES550pqe4rJJCeWJKanZpakFoEk5Xh4FCS4L0IMlSwKDU9tSItM6cEIc3E
	wQkynAdo+AWQGt7igsTc4sx0iPwpRkUpcd5bIAkBkERGaR5cLyxNvWIUB3pFGKKdB5ji4Lpf
	AQ1mAhp86+U3kMEliQgpqQbGKR9/TbqbFf7JTszwntik+ywNf4++Pb6i72LxmSPisybO6Zxk
	Zip9lvXwgg/KDu5dzGtm7Nme1P0o+tnPtQ7mbLqp/JJB5k/Fr8/laP1TmsNleaaZqfRmj2TN
	fxbTnSoL0i+br824+75HLvpWq9yxk0J9ZxbN+ai10KY86uWbo2/TOBlCs0JZlViKMxINtZiL
	ihMB5SBzxS4DAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2011 01:43 PM, Rakib Mullick wrote:
> On Tue, Jun 14, 2011 at 12:06 AM, Andrew Lutomirski<luto@mit.edu>  wrote:
>> On Mon, Jun 13, 2011 at 4:45 AM, Rakib Mullick<rakib.mullick@gmail.com>  wrote:
>>> On Mon, Jun 13, 2011 at 10:54 AM, Rakib Mullick<rakib.mullick@gmail.com>  wrote:
>>>> On Mon, Jun 13, 2011 at 8:52 AM, Andrew Lutomirski<luto@mit.edu>  wrote:
>>>>> On Sun, Jun 12, 2011 at 1:12 AM, Rakib Mullick<rakib.mullick@gmail.com>  wrote:
>>>>>> On Sat, Jun 11, 2011 at 5:01 PM, Andrew Lutomirski<luto@mit.edu>  wrote:
>>>>>>> On Sat, Jun 11, 2011 at 3:31 AM, Rakib Mullick<rakib.mullick@gmail.com>  wrote:
>>>>>
>>>>> I think there are three separate issues here:
>>>>>
>>>>> 1. Can ret be used uninitialized?  I say no, even as seen by the
>>>>> compiler.  If vsyscall_nr is 0, 1, or 2, then ret is initialized.  If
>>>>> vsyscall_nr is 3, then the BUG gets hit.  BUG is defined as some
>>>>> assembly magic followed by unreachable(), and the compiler is supposed
>>>>> to know that code after unreachable() is qunreachable.  So how can ret
>>>>> be used uninitialized?
>>>>>
>>>> I don't have much knowledge of advance assembly, so I really don't
>>>> understand that part - how BUG handles this. If it really makes sure
>>>> that, it will handle it properly then I think you can drop this patch.
>>>>
>>>>> What version of gcc do you have?  gcc (GCC) 4.6.0 20110530 (Red Hat
>>>>> 4.6.0-9) does not produce this warning.
>>>>>
>>>> Currently, I'm replying from outside my home. I'll let you know when
>>>> I'm back home.
>>>>
>>> Here is my GCC version - gcc version 4.5.1 20100924 (Red Hat 4.5.1-4)
>>> (GCC). I'm using Fedora 14.
>>
>> I also have gcc (GCC) 4.5.1 20100924 (Red Hat 4.5.1-4) on another box,
>> and I still can't reproduce this.
>>
>> Can you tell me which git revision you're building and send me your
>> .config and the output of:
>>
> I'm using 3.0.0-rc2 (lastly I pulled tip tree 3 days ago). I've
> attached the .config (config.log).
>
>> $ touch arch/x86/kernel/vsyscall_64.o
>> $ make V=1 arch/x86/kernel/vsyscall_64.o
>>
> Output of the above steps are attached (vsyscall_64.log). Hope that will help.

Aha!  You have CONFIG_BUG=n.  I'm not sure that fixing warnings for that 
case is worth it (or is even a good idea).

Can you try this patch, though:

Signed-off-by: Andy Lutomirski <luto@mit.edu>

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index dfb0ec6..f4083f4 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -107,11 +107,11 @@ extern void warn_slowpath_null(const char *file, 
const int line);

  #else /* !CONFIG_BUG */
  #ifndef HAVE_ARCH_BUG
-#define BUG() do {} while(0)
+#define BUG() do { unreachable(); } while(0)
  #endif

  #ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (condition) ; } while(0)
+#define BUG_ON(condition) do { if (condition) unreachable(); } while(0)
  #endif

  #ifndef HAVE_ARCH_WARN_ON

It may silence a lot of warnings, although it'll come at a cost of 
increased code size with CONFIG_BUG=n on older gcc.  On newer GCC, 
you'll get possibly faster and smaller code.

--Andy
