Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0KHKtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 05:49:15 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49076 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab0KHKtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 05:49:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=e2Nb1mwfdNcAqyJ1UUxIjrrtLlWYDgTaUump5UqJIj3K4e/VSCah5ABG5ofwBNHNyE
         CICQLCqgwSLB1dii2mZ8tiYC+L4bv3d4PqHjMSSDoZs/W9xElnrrF/vmR5hz7XAxKru6
         u88SkRclOpZ0KHtSh9v+FkfaLc4ZBBLyW6WWs=
MIME-Version: 1.0
In-Reply-To: <87k4kospnd.fsf@basil.nowhere.org>
References: <4CD538CA.8010901@xs4all.nl>
	<87wroostw3.fsf@basil.nowhere.org>
	<m2hbfsu57i.fsf@igel.home>
	<87k4kospnd.fsf@basil.nowhere.org>
Date: Mon, 8 Nov 2010 11:49:13 +0100
Message-ID: <AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com>
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
From: Richard Guenther <richard.guenther@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Jim <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 8, 2010 at 12:03 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Andreas Schwab <schwab@linux-m68k.org> writes:
>>
>> The asm fails to mention that it modifies *regs.
>
> It has a memory clobber, that should be enough, no?

No.  A memory clobber does not cover automatic storage.

Btw, I can't see a testcase anywhere so I just assume Andreas got
it right as usual.

Richard.

> Besides in any case it cannot be eliminated because it has
> valid non dead inputs and outputs.
>
> -Andi
> --
> ak@linux.intel.com -- Speaking for myself only.
>
