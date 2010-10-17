Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab0JQCET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 22:04:19 -0400
Received: from xenotime.net ([72.52.115.56]:39464 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756602Ab0JQCES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 22:04:18 -0400
Date: Sat, 16 Oct 2010 19:04:16 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Random compiler errors
Message-Id: <20101016190416.bdbfc69f.rdunlap@xenotime.net>
In-Reply-To: <20101016174854.4b8eec07@s6510>
References: <20101016174854.4b8eec07@s6510>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Oct 2010 17:48:54 -0700 Stephen Hemminger wrote:

> Not sure why this is happening, but lately when building kernels
> I am getting non-reproducible cases of gcc failure. There are no
> messages in system log. Cosmic rays? Bad memory?

I haven't had these personally, but from reading lkml over the past
N years, these are usually due to memory or disk/storage problems.


>   CC      arch/x86/kernel/xsave.o
>   CC      arch/x86/kernel/ptrace.o
> arch/x86/kernel/ptrace.c:1416: internal compiler error: Bus error
> Please submit a full bug report,
> with preprocessed source if appropriate.
> See <file:///usr/share/doc/gcc-4.4/README.Bugs> for instructions.
> make[2]: *** [arch/x86/kernel/ptrace.o] Error 1
> make[1]: *** [arch/x86/kernel] Error 2
> make: *** [arch/x86] Error 2
> 
> $ make
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   CC      arch/x86/kernel/ptrace.o
>   CC      arch/x86/kernel/tls.o
>   CC      arch/x86/kernel/step.o
>   CC      arch/x86/kernel/tboot.o
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
