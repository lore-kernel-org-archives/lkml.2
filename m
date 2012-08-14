Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab2HNQNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 12:13:51 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41134 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab2HNQNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 12:13:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120814134020.367361b5@pyramind.ukuu.org.uk>
References: <CAHP4M8WV64UMor_oU4UNgGx7P0Zet_M3yJrAZaCR+yYQmmeEYw@mail.gmail.com>
	<20120814134020.367361b5@pyramind.ukuu.org.uk>
Date: Tue, 14 Aug 2012 21:43:49 +0530
Message-ID: <CAHP4M8UhnkB085V8X5LVuj-JScdZWJdjcDMzvgwoL_opKKRpOw@mail.gmail.com>
Subject: Re: How to hack syscall-table, in kernel 2.6+ ?
From: Ajay Garg <ajaygargnsit@gmail.com>
To: richard.weinberger@gmail.com, balbi@ti.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Richard, Felipe, Alan.


First of all, let me tell you that I am highly previleged talking to
some of the most distinguished hackers in the world.
Alan, I truly admire you :)


So, the use-case I am trying to solve, is that only a particular
process should be able to read a group of files, and no one else (i.e.
no-other-user/ no-other-process/no-other-anything). The only exception
is the "root" user, and any user holding "sudo" previleges.

So, only a particular process (with a specified PID), the superuser,
and any user-carrying-sudo previleges, should be able to read a group
of files.


I am still in the process of reading Felipe's link to SeLinux; and it
seems that there might just be the way to achieve what I want :)
Let me figure out the details :)


Thanks and Regards,
Ajay



On Tue, Aug 14, 2012 at 6:10 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> I have already tried extracting the address of the "sys_call_table"
>> from "System.Map"; however, I am still not able to replace the
>> function-pointers with mine.
>
> Correct.
>
>> Trying to do gives me page-faults, apparently meaning that the
>> syscall-table memory area is read-only.
>
> Correct.
>
> The kernel is specifically designed to stop such uses by rootkits and
> trojans and other malware.
>
> If you are trying to patch the system call table you are doing something
> wrong. What are you actually trying to achieve ?
