Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426Ab1JNUX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:23:27 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58495 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab1JNUX0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:23:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAObL_7E-ZpRZqL3D2OoE81-46JU2-dcOO6ywYLzAJJRuP_7Ssw@mail.gmail.com>
References: <CAObL_7GJ_WztLEgBhPhJGhDOJmPqiPXcHPqS=1_Fa=S9_PmpNw@mail.gmail.com>
	<CAObL_7Hhdfneba2C_4Bg+M=4LCmebFL0BvZKfw0P6xO=JQukcg@mail.gmail.com>
	<CAObL_7HL1M00D7XDCtMgO1kDSh64N7LvwB0DVd7c8Afi-Ki-Gw@mail.gmail.com>
	<CAFLxGvx0Cpu0ePytdCSSzfO2or3ZL3j5QrghOE5eWHZCJt6C6g@mail.gmail.com>
	<CAObL_7FJy=BFmtuTd+CE_uF2+ra6LnQWGUp=g+1py_V9ukYvJg@mail.gmail.com>
	<CA+55aFyskjs9qPkoFom16veQXy5a-beWF95A7mCFexqanRiiKQ@mail.gmail.com>
	<CAObL_7HUhxsOVHYFovgxYu7r5YNju+n4Q45GZ9viCCW-GrxWhg@mail.gmail.com>
	<CAFLxGvx0QMrvG_ZsFE6C_xHn9JpWJ-aW-V=K9pm3OoXZc=NKxQ@mail.gmail.com>
	<20111010114840.GC17079@elte.hu>
	<CAObL_7EykEi0OkKMj=iZ=A=acyiOPqx-CbUJMu=rVrvyUN8seQ@mail.gmail.com>
	<20111011062253.GA3589@elte.hu>
	<4E947BC9.7040805@mit.edu>
	<CAFLxGvw3KfPCwGbh+80PLYu9DNELvcyY1uHZRncKuRwtX2uc2g@mail.gmail.com>
	<CAObL_7E-ZpRZqL3D2OoE81-46JU2-dcOO6ywYLzAJJRuP_7Ssw@mail.gmail.com>
Date: Fri, 14 Oct 2011 22:23:25 +0200
Message-ID: <CAFLxGvzt+ThLeH2j9A5N1ee4_uYDnF764qdKvLQ2UWgGuCVpfg@mail.gmail.com>
Subject: Re: [RFC] fixing the UML failure root cause
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Adrian Bunk <bunk@stusta.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 10:17 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Fri, Oct 14, 2011 at 12:53 PM, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
>> On Tue, Oct 11, 2011 at 7:24 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>>> What do you think of this approach?  If it seems good, I'll finish the
>>> patch and submit it.
>>>
>>> With this patch applied, UML appears to work, but it fills the log with
>>> exploit attempt warnings.  Any ideas on what to do about that?
>>>
>>
>> I can confirm that this patch works.
>> And I really like vsyscall=emulate because with that UML can trap vsyscalls. :-)
>
> Are you sure you don't mean vsyscall=native?  I suspect that UML can't
> actually trap vsyscalls in emulate mode right now, although that ought
> to be fixable.
>

Doesn't vsyscall_emu_64.S transform any vsyscall into a real syscall?
So UML can trap it.

-- 
Thanks,
//richard
