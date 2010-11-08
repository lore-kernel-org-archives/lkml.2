Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab0KHLUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:20:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54202 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab0KHLUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:20:07 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Richard Guenther <richard.guenther@gmail.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Jim <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
References: <4CD538CA.8010901@xs4all.nl> <87wroostw3.fsf@basil.nowhere.org>
	<m2hbfsu57i.fsf@igel.home> <87k4kospnd.fsf@basil.nowhere.org>
	<AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com>
Date: Mon, 08 Nov 2010 12:20:02 +0100
In-Reply-To: <AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com>
	(Richard Guenther's message of "Mon, 8 Nov 2010 11:49:13 +0100")
Message-ID: <877hgorrj1.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Guenther <richard.guenther@gmail.com> writes:

> On Mon, Nov 8, 2010 at 12:03 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> Andreas Schwab <schwab@linux-m68k.org> writes:
>>>
>>> The asm fails to mention that it modifies *regs.
>>
>> It has a memory clobber, that should be enough, no?
>
> No.  A memory clobber does not cover automatic storage.

That's a separate problem.

> Btw, I can't see a testcase anywhere so I just assume Andreas got
> it right as usual.

An asm with live inputs and outputs should never be optimized
way. If 4.5.1 started doing that it's seriously broken.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
