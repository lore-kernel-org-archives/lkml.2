Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab2IVAlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 20:41:47 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56012 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab2IVAlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 20:41:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
	<877grnows4.fsf@xmission.com> <505CE638.1030405@linux.intel.com>
Date: Fri, 21 Sep 2012 17:41:34 -0700
In-Reply-To: <505CE638.1030405@linux.intel.com> (H. Peter Anvin's message of
	"Fri, 21 Sep 2012 15:12:08 -0700")
Message-ID: <87sjaaj3cx.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+4YdxiIX21sal+zSocpMPelgR7EhQVvLs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@linux.intel.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 00/11] x86: Supervisor Mode Access Prevention
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@linux.intel.com> writes:

> On 09/21/2012 03:07 PM, Eric W. Biederman wrote:
>> 
>> Have you tested kexec in this environment?
>> 
>> This is the kind of cpu feature that when we enable it, frequently we
>> have to do something on the kexec path.
>> 
>> At a quick skim it looks like the kexec path is using kernel page table
>> entries and clearing all bits from cr4 except X86_CR4_PAE so I don't
>> actually expect this change will require anything on the kexec path.
>> 
>
> I have not, no, but as you quite correctly point out that shouldn't
> affect things.
>
> We should also change the kernel to start clean with CR4 -- the purpose
> of CR4 is to indicate which CPU features the OS is opting into.
>
> I think we do on x86-64 but not on x86-32 at the moment.
>
> This is an unrelated problem, though, and can be addressed later.

Agreed.  I just was just curious where things stood.

Eric

