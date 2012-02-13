Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750907Ab2BMFAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 00:00:23 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:38280 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab2BMFAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 00:00:22 -0500
Message-ID: <4F3898DB.2030907@linux.vnet.ibm.com>
Date: Mon, 13 Feb 2012 13:00:11 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: perf: kvm events analysis tool
References: <4F338CAA.10807@linux.vnet.ibm.com> <4F338D56.6010505@linux.vnet.ibm.com> <4F387DA4.7020503@gmail.com>
In-Reply-To: <4F387DA4.7020503@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 12021305-3864-0000-0000-0000015CB4E5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 11:04 AM, David Ahern wrote:

> Compile fails on Fedora 16, x86_64 with latest tip-perf-core branch:
> 
> 
> In file included from builtin-kvm-events.c:19:0:
> ../../arch/x86/include/asm/svm.h:133:1: error: packed attribute is
> unnecessary for ‘vmcb_seg’ [-Werror=packed]
> ../../arch/x86/include/asm/svm.h:178:1: error: packed attribute is
> unnecessary for ‘vmcb_save_area’ [-Werror=packed]
> ../../arch/x86/include/asm/svm.h:183:1: error: packed attribute is
> unnecessary for ‘vmcb’ [-Werror=packed]
> In file included from builtin-kvm-events.c:20:0:
> ../../arch/x86/include/asm/vmx.h:334:0: error: "REG_R8" redefined [-Werror]
> /usr/include/sys/ucontext.h:46:0: note: this is the location of the
> previous definition
> ../../arch/x86/include/asm/vmx.h:335:0: error: "REG_R9" redefined [-Werror]
> /usr/include/sys/ucontext.h:48:0: note: this is the location of the
> previous definition
> ../../arch/x86/include/asm/vmx.h:336:0: error: "REG_R10" redefined [-Werror]
> /usr/include/sys/ucontext.h:50:0: note: this is the location of the
> previous definition
> ../../arch/x86/include/asm/vmx.h:337:0: error: "REG_R11" redefined [-Werror]
> /usr/include/sys/ucontext.h:52:0: note: this is the location of the
> previous definition
> ../../arch/x86/include/asm/vmx.h:338:0: error: "REG_R12" redefined [-Werror]
> /usr/include/sys/ucontext.h:54:0: note: this is the location of the
> previous definition
> ../../arch/x86/include/asm/vmx.h:339:0: error: "REG_R13" redefined [-Werror]
> /usr/include/sys/ucontext.h:56:0: note: this is the location of the
> previous definition
> ../../arch/x86/include/asm/vmx.h:340:0: error: "REG_R14" redefined [-Werror]
> /usr/include/sys/ucontext.h:58:0: note: this is the location of the
> previous definition
> ../../arch/x86/include/asm/vmx.h:341:0: error: "REG_R15" redefined [-Werror]
> /usr/include/sys/ucontext.h:60:0: note: this is the location of the
> previous definition
> ../../arch/x86/include/asm/vmx.h:443:13: error: expected declaration
> specifiers or ‘...’ before numeric constant
> In file included from builtin-kvm-events.c:21:0:
> ../../arch/x86/include/asm/kvm_host.h:15:22: fatal error: linux/mm.h: No
> such file or directory
> cc1: all warnings being treated as errors
> 


The first patch(patch 1/3) should be applied!

Thank you, David! :)

