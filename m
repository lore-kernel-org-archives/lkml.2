Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab1HYUB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 16:01:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37984 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab1HYUBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 16:01:25 -0400
Message-ID: <4E56A9DE.7040909@zytor.com>
Date: Thu, 25 Aug 2011 13:00:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: Arnaud Lacombe <lacombar@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/vdso changes for v3.1
References: <20110722154219.GA25694@elte.hu> <CACqU3MUxUBzu9frjHLVoHUEKtaDEP+Gn7txm1wbxq=Qkv12ssw@mail.gmail.com> <CAObL_7HXMQxf+kYVMutdfAFNrSGYKJF2WPkSeWGK230r_zwskA@mail.gmail.com> <CACqU3MUbafosBVsycwFjH9sSq8GJumaeq+MKmeUPKD_zyHdGgw@mail.gmail.com> <CAObL_7Hi7du37D0PiRVFZZ5=yYGLm4oaGNYqQCeVoab5aJ_2NQ@mail.gmail.com> <CACqU3MXpihKOV_4whbi8_CSU4uFpFzbNFaXvSN75ChdYhZ0A5A@mail.gmail.com> <4E56A7DC.5090805@zytor.com> <CAObL_7HLpji6xDcBAmwUXBQuahLLVzQXAfYz_gXufUqj_cDzeQ@mail.gmail.com>
In-Reply-To: <CAObL_7HLpji6xDcBAmwUXBQuahLLVzQXAfYz_gXufUqj_cDzeQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2011 12:55 PM, Andrew Lutomirski wrote:
> On Thu, Aug 25, 2011 at 3:51 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 08/25/2011 12:47 PM, Arnaud Lacombe wrote:
>>>
>>> CPU: Intel QEMU Virtual CPU version 0.14.50 stepping 03
>>> About to apply_alternatives
>>> start=c13bee88 a=0 instr_offset=-3922530 instr=cpu_idle+0x26/0x60
>>> repl_offset=2336 repl=__alt_instructions_end+0x0/0x29f instrlen=5
>>> repllen=3
>>>   done
>>
>> Since this is a QEMU setup, could you share enough of the setup to
>> reproduce?
> 
> qemu-kvm -net none -kernel arch/x86/boot/bzImage -smp 2 -cpu host
> -nographic -append console=ttyS0
> 
> With Arnaud's 'dot-config' on the v3.1-rc3 tag.  Triggers instantly.
> It's definitely dependent on the config.
> 
> Is there any binutils magic to find out which file a particular
> address in .altinstructions came from?  I don't think there are
> meaningful symbols near it.
> 

addr2line might be able to tell you.

	-hpa

