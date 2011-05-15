Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab1EOGB7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 02:01:59 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:62925 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab1EOGBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 02:01:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uAfp+yyEjXOy6S8tc0BNh+W1fdUmD0jCaG+b7Q5L1Swjxh06XdKx04J7UmNErjAyLp
         ++akBgRqYLYaCboo5b3m2makpbGX1U1Q6G4tRzzcpS0WQI7RFy3pmntMj/w5sVSgwAyA
         7CII3sqgbkkqP6LCowJ44P7rhy6Us8SBnrLEs=
MIME-Version: 1.0
In-Reply-To: <1305295737.31204.112.camel@e102109-lin.cambridge.arm.com>
References: <BANLkTikefReiFUggT8iPv0mOmY=+OOOS-A@mail.gmail.com>
	<BANLkTim-FmuENeU_Cai+nYnTP+uJTEn3PA@mail.gmail.com>
	<BANLkTi=S3VR1mxc0bsL4+N3ksHeo3scg3A@mail.gmail.com>
	<009c01cc108b$4635c7d0$d2a15770$@com>
	<BANLkTi=wg=RgyEWzL9_fwUymhFDaccQCfw@mail.gmail.com>
	<BANLkTin9RLjsgu=frPGXL8mL8p8LPz-10w@mail.gmail.com>
	<BANLkTik=M8uwnmHABqYBkeVDk56UMrnkMg@mail.gmail.com>
	<BANLkTi=VesNU8ye=ntq-LAzBPG4pVYZPQQ@mail.gmail.com>
	<BANLkTik6c8-g8FrXZy8-V35W6-Th++5p_A@mail.gmail.com>
	<BANLkTi=bYzYrHx+P=yTH_0VTiQaGZHeB9A@mail.gmail.com>
	<1305295737.31204.112.camel@e102109-lin.cambridge.arm.com>
Date: Sun, 15 May 2011 14:01:47 +0800
Message-ID: <BANLkTimW+efD9FJzFjCzdSYCYRwAg+ZGtg@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOetlOWkjTogcHJvYmxlbSB3aXRoIGttZW1sZWFr?=
From: ttlxzz ccc <boyzccc@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Catalin=:)

I enable CONFIG_BACKTRACE_SELF_TEST and check the log

vim /var/log/kernel

and find the backtrace testing below:

May 15 13:48:54 db-sat-test05 kernel: ====[ backtrace testing ]===========
May 15 13:48:54 db-sat-test05 kernel: Testing a backtrace from process context.
May 15 13:48:54 db-sat-test05 kernel: The following trace is a kernel
self test and not a bug!
May 15 13:48:54 db-sat-test05 kernel: Pid: 1, comm: swapper Not
tainted 2.6.32_1-1-0-0 #7
May 15 13:48:54 db-sat-test05 kernel: Call Trace:
May 15 13:48:54 db-sat-test05 kernel:  [<ffffffff8108b5f9>] ?
backtrace_regression_test+0x50/0x16a
May 15 13:48:54 db-sat-test05 kernel:  [<ffffffff8117b143>] ?
proc_create_data+0xb3/0xe5
May 15 13:48:54 db-sat-test05 kernel:  [<ffffffff8182d6e1>] ?
kallsyms_init+0x0/0x30
May 15 13:48:54 db-sat-test05 kernel:  [<ffffffff8182d706>] ?
kallsyms_init+0x25/0x30
May 15 13:48:54 db-sat-test05 kernel:  [<ffffffff81009094>] ?
do_one_initcall+0x6c/0x1c0
May 15 13:48:54 db-sat-test05 kernel:  [<ffffffff8181133a>] ?
kernel_init+0x2f5/0x381
May 15 13:48:54 db-sat-test05 kernel:  [<ffffffff8100ca9a>] ? child_rip+0xa/0x20
May 15 13:48:54 db-sat-test05 kernel:  [<ffffffff81811045>] ?
kernel_init+0x0/0x381
May 15 13:48:54 db-sat-test05 kernel:  [<ffffffff8100ca90>] ? child_rip+0x0/0x20
May 15 13:48:54 db-sat-test05 kernel: Testing a backtrace from irq context.
May 15 13:48:54 db-sat-test05 kernel: The following trace is a kernel
self test and not a bug!
May 15 13:48:54 db-sat-test05 kernel: Pid: 22, comm: ksoftirqd/6 Not
tainted 2.6.32_1-1-0-0 #7
May 15 13:48:54 db-sat-test05 kernel: Call Trace:
May 15 13:48:54 db-sat-test05 kernel:  <IRQ>  [<ffffffff8108b595>] ?
backtrace_test_irq_callback+0xd/0x21
May 15 13:48:54 db-sat-test05 kernel:  [<ffffffff8105744e>] ?
tasklet_action+0x95/0xf8
May 15 13:48:54 db-sat-test05 kernel:  [<ffffffff81057034>] ?
__do_softirq+0xa9/0x154
May 15 13:48:54 db-sat-test05 kernel:  [<ffffffff81057892>] ?
ksoftirqd+0x0/0x16c
May 15 13:48:54 db-sat-test05 kernel:  [<ffffffff8100cb9c>] ?
call_softirq+0x1c/0x28
May 15 13:48:54 db-sat-test05 kernel:  <EOI>  [<ffffffff8100e8c1>] ?
do_softirq+0x47/0xbc
May 15 13:48:54 db-sat-test05 kernel:  [<ffffffff81057917>] ?
ksoftirqd+0x85/0x16c
May 15 13:48:54 db-sat-test05 kernel:  [<ffffffff8106b6e8>] ? kthread+0x9b/0xaa
May 15 13:48:54 db-sat-test05 kernel:  [<ffffffff8100ca9a>] ? child_rip+0xa/0x20
May 15 13:48:54 db-sat-test05 kernel:  [<ffffffff8106b64d>] ? kthread+0x0/0xaa
May 15 13:48:54 db-sat-test05 kernel:  [<ffffffff8100ca90>] ? child_rip+0x0/0x20
May 15 13:48:54 db-sat-test05 kernel: Testing a saved backtrace.
May 15 13:48:54 db-sat-test05 kernel: The following trace is a kernel
self test and not a bug!
May 15 13:48:54 db-sat-test05 kernel:  [<ffffffffffffffff>] 0xffffffffffffffff
May 15 13:48:54 db-sat-test05 kernel: ====[ end of backtrace testing ]====

Is there something wrong with the backtrace testing so that I can't
get the full backtrace, plz?

thank you very much:)

On Fri, May 13, 2011 at 10:08 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Fri, 2011-05-13 at 10:32 +0100, ttlxzz ccc wrote:
>> I have tested kmemleak on the x86 and x86_64 architecture again. There
>> is only
>>  backtrace:
>>
>>    [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> unreferenced object 0xffffc90012d27000 (size 64):
>>
>>  comm "insmod", pid 13092, jiffies 4298369684
>>
>>  hex dump (first 32 bytes):
>>
>>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>
>>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>
>>  backtrace:
>>
>>    [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> But in the x86, there is full backtrace.
>
> Can you enable CONFIG_BACKTRACE_SELF_TEST and check whether the
> boot-time backtrace test goes ok?
>
> --
> Catalin
>
>
>
