Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab1CNMvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 08:51:10 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48362 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639Ab1CNMvH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 08:51:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=Y2ERvGDK1JxYgHUtjB0TeYVr90rM7yyulwtmU5KN937zdSpzpfn0A6Aw3M0N6AvxGO
         nRpho1VCPFWaJeNPhoq0oVc4lX66VSoOKpztB6oFSwt6wX50Ilh5x1+ayEs5niEV4ndZ
         VqZe/9ScupYDFCMWxEP9bb6GrYSj3PCLQ6Pno=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <4D7E166C0200007800036451@vpn.id2.novell.com>
References: <AANLkTinDTyupNgZR-0izCWrpwOnE1wEcubn+M3o=Mgy2@mail.gmail.com>
	<4D7E095802000078000363D5@vpn.id2.novell.com>
	<AANLkTikUKE4xzf-NJtK3vMCQmNEYiAXZzi2vMZs9Zy4W@mail.gmail.com>
	<AANLkTimmi7A6cXo8BCHWtBDmauZD4_-dNjThpn1J9DkW@mail.gmail.com>
	<4D7E166C0200007800036451@vpn.id2.novell.com>
Date: Mon, 14 Mar 2011 13:51:05 +0100
Message-ID: <AANLkTikkWC47U_n--zWq+B-V0zPW+p85WLtPRczEdkNR@mail.gmail.com>
Subject: Re: PATCH: Add --size-check=[error|warning]
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, amodra@gmail.com,
        "H.J. Lu" <hjl.tools@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        binutils <binutils@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 1:21 PM, Jan Beulich <JBeulich@novell.com> wrote:
>>>> On 14.03.11 at 12:52, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>> On Mon, Mar 14, 2011 at 12:38 PM, Sedat Dilek
>> <sedat.dilek@googlemail.com> wrote:
>>> [ Changing Alan's Email to valid <amodra@gmail.com> in CC ]
>>>
>>> On Mon, Mar 14, 2011 at 12:26 PM, Jan Beulich <JBeulich@novell.com> wrote:
>>>>>>> On 14.03.11 at 12:02, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>> [...]
>>>>> [2] Where can someone set a "global behaviour" (hardcoded options) for
>>>>> his/her assembler in the kernel's build-system (speaking of
>>>>> "--size-check=[error|warning]")?
>>>>
>>>> Nowhere, selecting behavior is possible only via the command line.
>>>>
>>>
>>> Via command-line, something like this would do it?
>>>
>>>     $ export AS="/usr/bin/as --size-check=warning
>>> [...]
>
> No - $(AS) isn't being used to translate .S files, $(CC) is being used
> instead. That's why I pointed at the necessary -B option (so that
> the compiler would be able to locate the wrapper H.J. suggested).
>

OK, now I am enlightened in things of -B option.
Anyway, can I see the correct command line to use?
(OMG, I am glad this is not the $500.000 question @ "Who Wants to Be a
Millionaire?" quiz show. Jan wanna be my telephone joker :-)?)

>> By looking through the binutils source-code, I have seen ASFLAGS.
>>
>>      $ ASFLAGS="--size-check=warning" ; export ASFLAGS
>
> Where did you find that? All places where I see references to this
> variable are in the testsuite.
>
> Jan
>

WildWildWeb, IIRC I saw ASFLAGS used in a Gentoo package and AS in
Cross-LFS/binutils build instructions.

- Sedat -
