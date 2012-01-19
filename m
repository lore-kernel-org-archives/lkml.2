Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab2ASCJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 21:09:00 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:46443 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752784Ab2ASCI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 21:08:58 -0500
Message-ID: <4F1788EC.4040901@xenotime.net>
Date: Wed, 18 Jan 2012 19:07:24 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>
Subject: Re: linux-next: Tree for Jan 19 (uml)
References: <20120119125932.a4c67005cf6a0938558e8b36@canb.auug.org.au>
In-Reply-To: <20120119125932.a4c67005cf6a0938558e8b36@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 05:59 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20120118:
> 
> Linus' tree gained a build failure for which I applied a patch.


Building uml on x86_64 gives:

  CC      arch/um/kernel/asm-offsets.s
In file included from /next/linux-next-20120119/arch/um/include/shared/registers.h:9:0,
                 from /next/linux-next-20120119/arch/um/include/asm/processor-generic.h:14,
                 from /next/linux-next-20120119/arch/x86/um/asm/processor.h:20,
                 from /next/linux-next-20120119/arch/um/include/asm/uaccess.h:16,
                 from /next/linux-next-20120119/arch/um/include/asm/thread_info.h:13,
                 from /next/linux-next-20120119/include/linux/thread_info.h:53,
                 from /next/linux-next-20120119/include/linux/preempt.h:9,
                 from /next/linux-next-20120119/include/linux/spinlock.h:50,
                 from /next/linux-next-20120119/include/linux/seqlock.h:29,
                 from /next/linux-next-20120119/include/linux/time.h:8,
                 from /next/linux-next-20120119/include/linux/timex.h:56,
                 from /next/linux-next-20120119/include/linux/sched.h:57,
                 from /next/linux-next-20120119/arch/x86/um/shared/sysdep/kernel-offsets.h:2,
                 from /next/linux-next-20120119/arch/um/kernel/asm-offsets.c:1:
/next/linux-next-20120119/arch/x86/um/shared/sysdep/ptrace.h:7:20: error: redefinition of 'regs_return_value'
/next/linux-next-20120119/arch/x86/um/shared/sysdep/ptrace.h:7:20: note: previous definition of 'regs_return_value' was here



-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
