Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab1GYKNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:13:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33852 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab1GYKNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:13:16 -0400
MIME-Version: 1.0
In-Reply-To: <m1r5n7ln0l.fsf@fess.ebiederm.org>
References: <5f6c52c61003241920i6b3eaaf7k946f67d1a6f9e384@mail.gmail.com>
	<m1r5n7ln0l.fsf@fess.ebiederm.org>
Date: Mon, 25 Jul 2011 18:13:16 +0800
Message-ID: <CAKdQVUZMC0eaeqev=tAbS2myHJOA1KJt4r8TVMz6=yQeDpUpZQ@mail.gmail.com>
Subject: Re: x86_64 virtual memory map
From: Bob Zhang <zhanglinbao@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: hayfeng Lee <omycle@gmail.com>, ak@linux.intel.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Bob Zhang <2004.zhang@gmail.com>, zhanglinbao@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks in advanced!

I searched this question , so I directly reply to this mail.

1, for x86_64 machine ,for example ,HP's proliant machine.
from the kernel point of view , what is the max physical ram size ?
if I install 2TB physical memory(I mean physical RAM) , can linux
kernel recognize 2TB physical memory ?  from mm.txt , it seems that
physical ram size should be 64TB.

2,
from mm.txt :(http://lxr.linux.no/linux+v2.6.39/Documentation/x86/x86_64/mm.txt
from latest 2.6.39.

I am a little confused .
above said that :
ffff880000000000 - ffffc7ffffffffff (=64 TB) direct mapping of all phys. memory
10ffffc80000000000 - ffffc8ffffffffff (=40 bits) hole
11ffffc90000000000 - ffffe8ffffffffff (=45 bits) vmalloc/ioremap space  :32TB
ffffea0000000000 - ffffeaffffffffff (=40 bits) virtual memory map (1TB)
from this , we can know ,we can used max 64TB physical memory(physical
RAM).  vmalloc/ioremap space :32TB . but why tell us 1TB virtual
memory map ?  if the address that  vmalloc allocated are the address
that we can use , why say like this ? I am puzzled.
for example ,for 32bit kernel .vmalloc() range

and in the end of mm.txt , it says :
>>Current X86-64 implementations only support 40 bits of address space,
 >> 27but we support up to 46 bits. This expands into MBZ space in the
>>page tables.
so this 40bit(1TB) is responding to virtual memory map(1TB) ?

3,  if I installed 64TB physical memory (RAM) , but linux kernel only
support 1TB address space , what should I do next ?

4 , it seems that MBZ can support up to 256TB ,but who can tell how to
expand address space by MBZ ?
thanks very much!

-Bob
