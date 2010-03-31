Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab0CaTgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 15:36:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53054 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719Ab0CaTgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 15:36:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BRHnFWBKg8oLUAGDQ2ng9HRNddQ4PPgXTIO8FcpaatPs7BRCovjVr3/78cELRIeesL
         L28ZqVj2PV/xlXkVqYEj9aotQBsDfMtFP+TLH0KB1PHnjQc6KRppXRaEIrNKGvNJcKjT
         Fz86CChtTGnq41cHKQ0tA2hTAEAFmkm31xbJs=
MIME-Version: 1.0
In-Reply-To: <m2k4svuni6.fsf@igel.home>
References: <b2cc26e41003241537h228028c4n1374f4b042175885@mail.gmail.com>
	 <b2cc26e41003251229w5d266c18gd17fdcf404136bd7@mail.gmail.com>
	 <ff13bc9a1003251400ted1993ao73c15ee86e3e717a@mail.gmail.com>
	 <a36005b51003260456m441568c1vcc8b90eed0421b9d@mail.gmail.com>
	 <ff13bc9a1003261406w7bf4bb77sf57edce14f0dcc73@mail.gmail.com>
	 <a36005b51003261415u1cc89f84r843abaa81f1d7396@mail.gmail.com>
	 <b2cc26e41003270450w1a90f9b2j5cbbae9726122b4e@mail.gmail.com>
	 <a36005b51003270505s42b5e69co14d2acbb27dc204a@mail.gmail.com>
	 <b2cc26e41003290740i5c548cabgc95d91958cd1075a@mail.gmail.com>
	 <m2k4svuni6.fsf@igel.home>
Date: Wed, 31 Mar 2010 21:36:45 +0200
Message-ID: <r2rb2cc26e41003311236mb281e842pbdaf6e7632e288a8@mail.gmail.com>
Subject: Re: execve() returns ENOENT when ld-linux.so isn't found
From: Olaf van der Spek <olafvdspek@gmail.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Ulrich Drepper <drepper@gmail.com>,
       Luca Barbieri <luca.barbieri@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 6:00 PM, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Olaf van der Spek <olafvdspek@gmail.com> writes:
>
>> File not found is a very common error message with a pretty will
>> understood meaning.
>
> And perfectly applicable here (as you write yourself in the subject).

No, it's not. It does not apply to the argument of the function called.

>> Overloading another error code would avoid this confusion, especially
>> since it's far less used.
>
> Changing a well understood error number into a totally misleading one
> only increases confusion.

Why is it totally misleading? The proposed new one is actually very close.

Olaf
