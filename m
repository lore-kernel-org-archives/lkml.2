Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab1CHOzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 09:55:06 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38504 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab1CHOzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 09:55:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Wy1QQHyCelJRTeVSmqxQGgI/b0ClGJfhCi84l2ir3OPjEufAjW96yaFk0Gp9xl7M1b
         9rMb/yyhiYcDIZ7LauR5/jPikqi8/+d5aEcdkLe7HuMKtBVBhiEuDVLQTGGMv1oOdfUk
         Pj/m/36zFdHvIZvxQo5BhJ1WjwetUTkrt1djU=
MIME-Version: 1.0
In-Reply-To: <AANLkTin2H9=NWp5G6N6_e=bxBTh2eS1dbUxOjT6xX98C@mail.gmail.com>
References: <AANLkTin2H9=NWp5G6N6_e=bxBTh2eS1dbUxOjT6xX98C@mail.gmail.com>
Date: Tue, 8 Mar 2011 06:55:03 -0800
Message-ID: <AANLkTik_Cb7tXheZNOBjqnoQc4MSL1LnDtFGFP5mqZRi@mail.gmail.com>
Subject: Re: linux-next: Tree for March 8 (BROKEN: arch/x86/kernel/entry_32.S?
 Debian's binutils/as?)
From: "H.J. Lu" <hjl.tools@gmail.com>
To: sedat.dilek@gmail.com
Cc: Sedat Dilek <sedat.dilek@googlemail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Matthias Klose <doko@debian.org>,
        linux-next <linux-next@vger.kernel.org>,
        debian-gcc <debian-gcc@lists.debian.org>,
        binutils <binutils@sourceware.org>, psomas@cslab.ece.ntua.gr,
        JBeulich@novell.com, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 8, 2011 at 2:44 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> Hi,
>
> my build of linux-next (next-20110308, the same with the one from
> yesterday) is broken.
> (I translated the German output.)
>
> [ build.log ]
>  AS      arch/x86/kernel/entry_32.o
> /home/sd/src/linux-2.6/linux-2.6.38-rc7/debian/build/source_i386_none/arch/x86/kernel/entry_32.S:
> Assembler messages:
> /home/sd/src/linux-2.6/linux-2.6.38-rc7/debian/build/source_i386_none/arch/x86/kernel/entry_32.S:1421:
> Error: .size expression does not evaluate to a constant
> make[6]: *** [arch/x86/kernel/entry_32.o] Fehler 1 (Error 1)
> make[5]: *** [arch/x86/kernel] Fehler 2 (Error 2)
> make[4]: *** [arch/x86] Fehler 2 (Error 2)
> make[4]: *** Warte auf noch nicht beendete Prozesse... (Waiting for
> unfinished jobs...)
>

This is a kernel bug.  Please use the latest binutils from CVS.
It will tell you which symbol causes this.


-- 
H.J.
