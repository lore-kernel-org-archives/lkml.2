Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab1HOS2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 14:28:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57659 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab1HOS2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 14:28:06 -0400
Message-ID: <4E4964F1.1020900@zytor.com>
Date: Mon, 15 Aug 2011 11:26:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: Borislav Petkov <bp@alien8.de>, melwyn lobo <linux.melwyn@gmail.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
Subject: Re: x86 memcpy performance
References: <a5a38901541cbe2805361c1887f2f395.squirrel@www.skyhub.de> <4E493449.70907@mit.edu> <be840e9d6d1ff3fdb94ce2ac23a15338.squirrel@www.skyhub.de> <CAObL_7GmMPBKa4QwcnUeehowzvTUdqXN7yswAfXsy8q71ZJzmg@mail.gmail.com> <4E494557.8080708@zytor.com> <CAObL_7HAhSaknKRD=0BGWYdZaanX9fOc+i2B74K844T=1r6yGg@mail.gmail.com>
In-Reply-To: <CAObL_7HAhSaknKRD=0BGWYdZaanX9fOc+i2B74K844T=1r6yGg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2011 09:58 AM, Andrew Lutomirski wrote:
> On Mon, Aug 15, 2011 at 12:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 08/15/2011 08:36 AM, Andrew Lutomirski wrote:
>>>
>>> (*)  kernel_fpu_begin is a bad name.  It's only safe to use integer
>>> instructions inside a kernel_fpu_begin section because MXCSR (and the
>>> 387 equivalent) could contain garbage.
>>>
>>
>> Uh... no, it just means you have to initialize the settings.  It's a
>> perfectly good name, it's called kernel_fpu_begin, not kernel_fp_begin.
> 
> I prefer get_xstate / put_xstate, but this could rapidly devolve into
> bikeshedding. :)
> 

a) Quite.

b) xstate is not architecture-neutral.

	-hpa

