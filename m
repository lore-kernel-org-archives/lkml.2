Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab2KQSei (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 13:34:38 -0500
Received: from mail.wdtv.com ([66.118.69.84]:37277 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab2KQSeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 13:34:37 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Borislav Petkov <bp@alien8.de>, Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, herrmann.der.user@googlemail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, microcode, AMD: Add support for family 16h processors
Date: Sat, 17 Nov 2012 13:34:33 -0500
References: <1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com> <50A57C35.10906@amd.com> <20121117144117.GD16441@x1.osrc.amd.com>
In-Reply-To: <20121117144117.GD16441@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201211171334.34239.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 November 2012, Borislav Petkov wrote:
>On Thu, Nov 15, 2012 at 06:35:17PM -0500, Boris Ostrovsky wrote:
>> One possibility is that BIOS already incorporated all patches (which
>> typically is the case) and so the driver doesn't have to do anything.
>
>/proc/cpuinfo contains ucode version and the processor's f/m/s, which
>is enough information to tell us whether your old phenom needs ucode
>patching.
>
>Thanks.
Well, in my case that returns 4 stanza's of this:
processor	: 3
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 2
model name	: AMD Phenom(tm) 9550 Quad-Core Processor
stepping	: 3
cpu MHz		: 2210.462
cache size	: 512 KB
physical id	: 0
siblings	: 4
core id		: 3
cpu cores	: 4
apicid		: 3
initial apicid	: 3
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov 
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb 
rdtscp lm 3dnowext 3dnow constant_tsc nonstop_tsc extd_apicid pni monitor 
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 
3dnowprefetch osvw ibs
bogomips	: 4420.70
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

And I don't see anything there that looks like a 'patch level'.
The ucode obviously can, which is what counts in this game of horseshoes.  
Perhaps something in that very long 'flags' string?

Thanks Borislav.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
My web page: <http://coyoteden.dyndns-free.com:85/gene> is up!
Biz is better.
