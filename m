Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab2BMFcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 00:32:15 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50761 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab2BMFcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 00:32:14 -0500
Date: Sun, 12 Feb 2012 22:32:08 -0700
Subject: Re: [PATCH 3/3] KVM: perf: kvm events analysis tool
Message-ID: <j8pru203h6n22hdd9bryyyfr.1329110982240@email.android.com>
From: David Ahern <dsahern@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1D5WLhp032195

[sorry for the top post - you would think Android would have a better mail client]

If the first patch is needed then kvm-events will not work with older, unpatched kernels. That's a big limitation from a perf perpective.

David

Sent from my ASUS Eee Pad

Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

>On 02/13/2012 11:04 AM, David Ahern wrote:
>
>> Compile fails on Fedora 16, x86_64 with latest tip-perf-core branch:
>> 
>> 
>> In file included from builtin-kvm-events.c:19:0:
>> ../../arch/x86/include/asm/svm.h:133:1: error: packed attribute is
>> unnecessary for â€˜vmcb_segâ€™ [-Werror=packed]
>> ../../arch/x86/include/asm/svm.h:178:1: error: packed attribute is
>> unnecessary for â€˜vmcb_save_areaâ€™ [-Werror=packed]
>> ../../arch/x86/include/asm/svm.h:183:1: error: packed attribute is
>> unnecessary for â€˜vmcbâ€™ [-Werror=packed]
>> In file included from builtin-kvm-events.c:20:0:
>> ../../arch/x86/include/asm/vmx.h:334:0: error: "REG_R8" redefined [-Werror]
>> /usr/include/sys/ucontext.h:46:0: note: this is the location of the
>> previous definition
>> ../../arch/x86/include/asm/vmx.h:335:0: error: "REG_R9" redefined [-Werror]
>> /usr/include/sys/ucontext.h:48:0: note: this is the location of the
>> previous definition
>> ../../arch/x86/include/asm/vmx.h:336:0: error: "REG_R10" redefined [-Werror]
>> /usr/include/sys/ucontext.h:50:0: note: this is the location of the
>> previous definition
>> ../../arch/x86/include/asm/vmx.h:337:0: error: "REG_R11" redefined [-Werror]
>> /usr/include/sys/ucontext.h:52:0: note: this is the location of the
>> previous definition
>> ../../arch/x86/include/asm/vmx.h:338:0: error: "REG_R12" redefined [-Werror]
>> /usr/include/sys/ucontext.h:54:0: note: this is the location of the
>> previous definition
>> ../../arch/x86/include/asm/vmx.h:339:0: error: "REG_R13" redefined [-Werror]
>> /usr/include/sys/ucontext.h:56:0: note: this is the location of the
>> previous definition
>> ../../arch/x86/include/asm/vmx.h:340:0: error: "REG_R14" redefined [-Werror]
>> /usr/include/sys/ucontext.h:58:0: note: this is the location of the
>> previous definition
>> ../../arch/x86/include/asm/vmx.h:341:0: error: "REG_R15" redefined [-Werror]
>> /usr/include/sys/ucontext.h:60:0: note: this is the location of the
>> previous definition
>> ../../arch/x86/include/asm/vmx.h:443:13: error: expected declaration
>> specifiers or â€˜...â€™ before numeric constant
>> In file included from builtin-kvm-events.c:21:0:
>> ../../arch/x86/include/asm/kvm_host.h:15:22: fatal error: linux/mm.h: No
>> such file or directory
>> cc1: all warnings being treated as errors
>> 
>
>
>The first patch(patch 1/3) should be applied!
>
>Thank you, David! :)
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
