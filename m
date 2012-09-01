Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab2IAUMW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 16:12:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61759 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666Ab2IAUMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 16:12:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAGDaZ_p5B-=Uf9PuHer9OiuUdAkRKy4aGt90T=FnKqE3M3sgwA@mail.gmail.com>
References: <CALKntY00bG_wVpOGM_L9ENLqROgSO_TttXJeTkgkERdtpnwi_A@mail.gmail.com>
	<CAGDaZ_p5B-=Uf9PuHer9OiuUdAkRKy4aGt90T=FnKqE3M3sgwA@mail.gmail.com>
Date: Sat, 1 Sep 2012 13:12:20 -0700
Message-ID: <CALKntY3Pi8fxQpG6CzuP-DHGYPjhXNNL7M1nqiMBxUgLMv3frA@mail.gmail.com>
Subject: Re: linux page table
From: Xin Tong <xerox.time.tech@gmail.com>
To: Shentino <shentino@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 1, 2012 at 1:01 PM, Shentino <shentino@gmail.com> wrote:
> On Sat, Sep 1, 2012 at 12:30 PM, Xin Tong <xerox.time.tech@gmail.com> wrote:
>> When a process is created in Linux, corresponding page table is
>> implemented. In the current x86 linux, the page table is a multi-level
>> page table and CR3 points to the first level of the page table.  I
>> have 2 questions.
>>
>> 1. is the value in CR3 virtual address or physical address ?
>
> It's a physical address.  It points the CPU to it in physical memory.
>
> More generally, all addresses in page tables, directories, etc are
> physical addresses.
>
>> 2. can the address of the first level of the page table during a
>> process's lifetime change ?
>
> This I don't know.
>
>> 3. can two different processes have their CR3 being the same value
>> even though they have different first level page tables ?
>
> I'm not sure about this, but I think CR3 is actually bound to the
> mm_struct and not the process.
>
> Think about separate processes with the same address space, such as
> multithreaded processes.

Do not all the threads share the same address space in a multithreaded program ?

Xin

>
>>
>> Thanks
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
