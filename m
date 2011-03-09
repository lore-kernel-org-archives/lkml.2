Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab1CIKQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 05:16:35 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45261 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1CIKQc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 05:16:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=E0z7b/yw+ZqnZLKd+JIPrOkRUAJEU+Sna6XK00schSLQmDHgLjlEDs0rO31iXPG8Ig
         nuliuXyfTc80LckE1JCm/5dG7vmWpqWuCgjxBjSd7xiD4nQUCYArzXa/jLdJIEAFcleY
         /f7HDjNANGwBBGAFuQ+lxsohtIAAcV4UE8Hmk=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110309085150.GC21294@elte.hu>
References: <AANLkTin2H9=NWp5G6N6_e=bxBTh2eS1dbUxOjT6xX98C@mail.gmail.com>
	<AANLkTik_Cb7tXheZNOBjqnoQc4MSL1LnDtFGFP5mqZRi@mail.gmail.com>
	<AANLkTinBv__n7k3Z=EJWv1fdQScyB7AJV0SsYJE0mCwQ@mail.gmail.com>
	<AANLkTiknsT1iQzUQ_oBiOORaqWBFyk2BaLq_xu9C5E_G@mail.gmail.com>
	<1299605269.29313.1427511237@webmail.messagingengine.com>
	<AANLkTi=6YstJxad41knR4Q9WN3wYKikPv-g1i3kg3HS1@mail.gmail.com>
	<1299615939.25628.1427572905@webmail.messagingengine.com>
	<AANLkTimBMP1jiuEEUwmKKVNZcZnrkFxFA_YBcLmkEFJM@mail.gmail.com>
	<AANLkTikpMAXfG5aNWo8x7pKKppaQiE-U8qjFaG0B2azV@mail.gmail.com>
	<20110309085150.GC21294@elte.hu>
Date: Wed, 9 Mar 2011 11:16:30 +0100
Message-ID: <AANLkTinLAZubVih-y6=EsGnd0yLmFDUcG10u-EbozUS0@mail.gmail.com>
Subject: Re: linux-next: Tree for March 8 (BROKEN: arch/x86/kernel/entry_32.S?
 Debian's binutils/as?)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H.J. Lu" <hjl.tools@gmail.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        linux-next <linux-next@vger.kernel.org>, psomas@cslab.ece.ntua.gr,
        Jan Beulich <JBeulich@novell.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 9, 2011 at 9:51 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * H.J. Lu <hjl.tools@gmail.com> wrote:
>
>> On Tue, Mar 8, 2011 at 12:33 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>> > On Tue, Mar 8, 2011 at 9:25 PM, Alexander van Heukelum
>> > <heukelum@fastmail.fm> wrote:
>> >> On Tue, 08 Mar 2011 18:53 +0100, "Sedat Dilek" <sedat.dilek@googlemail.com> wrote:
>> >>> On Tue, Mar 8, 2011 at 6:27 PM, Alexander van Heukelum
>> >>> <heukelum@fastmail.fm> wrote:
>> >>> > On Tue, 08 Mar 2011 16:42 +0100, "Sedat Dilek" <sedat.dilek@googlemail.com> wrote:
>> >>> >> On 3/8/11, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>> >>> >> > On 3/8/11, H.J. Lu <hjl.tools@gmail.com> wrote:
>> >>> >> >> On Tue, Mar 8, 2011 at 2:44 AM, Sedat Dilek <sedat.dilek@googlemail.com>
>> >>> >> >> wrote:
>> >>> >> >>> Hi,
>> >>> >> >>>
>> >>> >> >>> my build of linux-next (next-20110308, the same with the one from
>> >>> >> >>> yesterday) is broken.
>> >>> >> >>> (I translated the German output.)
>> >>> >> >>>
>> >>> >> >>> [ build.log ]
>> >>> >> >>>  AS      arch/x86/kernel/entry_32.o
>> >>> >> >>> /home/sd/src/linux-2.6/linux-2.6.38-rc7/debian/build/source_i386_none/arch/x86/kernel/entry_32.S:
>> >>> >> >>> Assembler messages:
>> >>> >> >>> /home/sd/src/linux-2.6/linux-2.6.38-rc7/debian/build/source_i386_none/arch/x86/kernel/entry_32.S:1421:
>> >>> >> >>> Error: .size expression does not evaluate to a constant
>> >>> >> >>> make[6]: *** [arch/x86/kernel/entry_32.o] Fehler 1 (Error 1)
>> >>> >> >>> make[5]: *** [arch/x86/kernel] Fehler 2 (Error 2)
>> >>> >> >>> make[4]: *** [arch/x86] Fehler 2 (Error 2)
>> >>> >> >>> make[4]: *** Warte auf noch nicht beendete Prozesse... (Waiting for
>> >>> >> >>> unfinished jobs...)
>> >>> >> >>>
>> >>> >> >>
>> >>> >> >> This is a kernel bug.  Please use the latest binutils from CVS.
>> >>> >> >> It will tell you which symbol causes this.
>> >>> >> >>
>> >>> >> >>
>> >>> >> >> --
>> >>> >> >> H.J.
>> >>> >> >>
>> >>> >> >
>> >>> >> > Yeah, I have cherry-picked these two upstream commits before you have
>> >>> >> > mentionned it...
>> >>> >> >
>> >>> >> > 0001-Mention-symbol-name-in-non-constant-.size-expression.patch
>> >>> >> >        (Cherry-picked from commit b9521fc0be7945fc842ce1197e241a023378125d)
>> >>> >> > 0002-Revert-the-last-change-on-gas-elf-bad-size.err.patch
>> >>> >> >        (Cherry-picked from commit cbd141bb69f791de7ea1581abe7afb34f0c61288)
>> >>> >> >
>> >>> >> > ... and have built with them a new binutils Debian package.
>> >>> >> >
>> >>> >> > The error looks now like this (sorry for the German output):
>> >>> >> > ...
>> >>> >> >   AS      arch/x86/kernel/entry_32.o
>> >>> >> > /home/sd/src/linux-2.6/linux-2.6.38-rc7/debian/build/source_i386_none/arch/x86/kernel/entry_32.S:
>> >>> >> > Assembler messages:
>> >>> >> > /home/sd/src/linux-2.6/linux-2.6.38-rc7/debian/build/source_i386_none/arch/x86/kernel/entry_32.S:1421:
>> >>> >> > Error: .size expression with symbol `apf_page_fault' does not evaluate
>> >>> >> > to a constant
>> >>> >> > make[6]: *** [arch/x86/kernel/entry_32.o] Fehler 1
>> >>> >> > make[5]: *** [arch/x86/kernel] Fehler 2
>> >>> >> > make[5]: *** Warte auf noch nicht beendete Prozesse...
>> >>> >> >
>> >>> >> > Anyway, before more riddling around it would be very helpful to have a
>> >>> >> > clear pointer if there is a fix around... That building, testing and
>> >>> >> > installing took me now several hours.
>> >>> >> > And... yeah, backports to 2.21-branch appreciated.
>> >>> >> >
>> >>> >> > - Sedat -
>> >>> >> >
>> >>> >>
>> >>> >> After a quick look into the source, it seems attached patch fixes the
>> >>> >> issue.
>> >>> >> Is that OK?
>> >>> >
>> >>> > Hi Sedat,
>> >>> >
>> >>> > The patch ( https://lkml.org/lkml/2011/3/8/203 ) is ok, feel free to add
>> >>> > Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
>> >>> >
>> >>> > Better description might be something like:
>> >>> >
>> >>> > i386: Fix mismatched ENTRY/END pair.
>> >>> >
>> >>> > Under CONFIG_KVM_GUEST=y, the following part of entry_32.S causes a compile failure.
>> >>> >
>> >>> > 1409 #ifdef CONFIG_KVM_GUEST
>> >>> > 1410 ENTRY(async_page_fault)
>> >>> > 1411         RING0_EC_FRAME
>> >>> > 1412         pushl $do_async_page_fault
>> >>> > 1413         CFI_ADJUST_CFA_OFFSET 4
>> >>> > 1414         jmp error_code
>> >>> > 1415         CFI_ENDPROC
>> >>> > 1416 END(apf_page_fault)
>> >>> > 1417 #endif
>> >>> >
>> >>> > Replace apf_page_fault with async_page_fault, as intended.
>> >>> >
>> >>> > Greetings,
>> >>> >    Alexander
>> >>> >
>> >>> >> - Sedat -
>> >>> >>
>> >>> >> Email had 1 attachment:
>> >>> >> + 0001-x86-Fix-build-failure-with-binutils-as-from-upstream.patch
>> >>> >>   1k (text/x-patch)
>> >>> >
>> >>>
>> >>> As I said, quick view on the code, quick fix :-).
>> >>>
>> >>> Your description is definitive more meaningful.
>> >>> I can refresh my patch and add your ACK.
>> >>>
>> >>> Anyway, I continued after dinner and with the above patch I ran into
>> >>> the next problem:
>> >>> [ build.log ]
>> >>> ...
>> >>>   AS      arch/x86/kernel/acpi/wakeup_rm.o
>> >>> /home/sd/src/linux-2.6/linux-2.6.38-rc7/debian/build/source_i386_none/arch/x86/kernel/acpi/wakeup_rm.S:
>> >>> Assembler messages:
>> >>> /home/sd/src/linux-2.6/linux-2.6.38-rc7/debian/build/source_i386_none/arch/x86/kernel/acpi/wakeup_rm.S:12:
>> >>> Error: .size expression with symbol `wakeup_code_start' does not
>> >>> evaluate to a constant
>> >>
>> >> No idea what's wrong there. But my version of wakeup_rm.S has only 10 lines...
>> >>
>> >>     1  /*
>> >>     2   * Wrapper script for the realmode binary as a transport object
>> >>     3   * before copying to low memory.
>> >>     4   */
>> >>     5          .section ".rodata","a"
>> >>     6          .globl  wakeup_code_start, wakeup_code_end
>> >>     7  wakeup_code_start:
>> >>     8          .incbin "arch/x86/kernel/acpi/realmode/wakeup.bin"
>> >>     9  wakeup_code_end:
>> >>    10          .size   wakeup_code_start, .-wakeup_code_start
>> >>
>> >> And it compiles just fine.
>> >> The fix for entry_32.S is valid, though, and necessary for mainline.
>> >>
>> >> Greetings,
>> >>    Alexander
>> >>
>> >>> I am unsure how to fix that and open for feedback.
>> >>>
>> >>> - Sedat -
>> >>>
>> >>
>> >
>> > The file in linux-next (next-20110308) looks different (the above code
>> > looks more logical to me)
>> >
>> > [ arch/x86/kernel/acpi/wakeup_rm.S ]
>> >
>> > /*
>> >  * Wrapper script for the realmode binary as a transport object
>> >  * before copying to low memory.
>> >  */
>> > #include <asm/page_types.h>
>> >
>> >        .section ".x86_trampoline","a"
>> >        .balign PAGE_SIZE
>> >        .globl  acpi_wakeup_code
>> > acpi_wakeup_code:
>> >        .incbin "arch/x86/kernel/acpi/realmode/wakeup.bin"
>> >        .size   wakeup_code_start, .-wakeup_code_start
>> >
>>
>> Those are simply wrong.  2.6.38-rc8 is OK.
>
> 2.6.37-rc8 is not OK: for example commit 631bc4878220932fe67fc46fc7cf7cccdb1ec597 is
> already upstream and if you enable KVM you see a broken kernel build with new
> binutils. This is from 2.6.38-rc8:
>
>  #ifdef CONFIG_KVM_GUEST
>  ENTRY(async_page_fault)
>        RING0_EC_FRAME
>        pushl $do_async_page_fault
>        CFI_ADJUST_CFA_OFFSET 4
>        jmp error_code
>        CFI_ENDPROC
>  END(apf_page_fault)
>  #endif
>
> Yes, the .size directive not matching up is technically a bug, but it was not
> checked by binutils before, for *years* - and you cannot just flip a switch and
> break who knows how much code.
>
> You need to at least emit a warning for some time to give people a *chance* to fix
> bugs - not just stuff an incompatible binutils down their throat and break the
> kernel build for thousands of commits and break bisection.
>
> This binutils change is breaking numerous upstream kernel builds (and is making
> bisection with new binutils impossible) for no particular good reason: binutils was
> capable to figure out the symbol name before this change.
>
> At minimum you need to *understand* that what you are doing is an incompatible
> change and is disruptive to others ...
>
> Thanks,
>
>        Ingo
>

OK, I am not a toolchain expert, but this recent changes to upstream
binutils were helpful to find at least the problematic place in the
code (fix see [1]).
I only needed a blink of an eye to catch it.
binutils 2.21 GIT has this change "PR gas/12519" which was not "perfect".
With the patch in upstream (see [2], which should be cherry-picked for
2.21-GIT as I did for my debianized binutils), there is more
"verbosity", now.
We have now an advantage as we know what's going on *before* final
binutils-2.21 release.

What are you expecting from binutils developers?
Shall they revert the above PR (yes, I also build a binutils with a
revert of it)?

The next place in code (I am on linux-next) could also be found easily
and with some help of x86 folks it could be fixed [2], too.

Can you please explain the "incompatibility" and "breakage" with older
kernels (especially for bisecting sounds awful)?
(I am just curious and the several builds of binutils and linux-next
kernels I did yesterday should not be for nothing :-).)

If I can help (like testing or whatever), please let me know.

- Sedat -

[1] https://patchwork.kernel.org/patch/619081/
[2] http://sourceware.org/ml/binutils/2011-03/msg00078.html
[3] https://patchwork.kernel.org/patch/619611/
