Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab2E3OnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:43:11 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:59543 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2E3OnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:43:07 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Philippe De Muyter <phdm@macqel.be>, linux-m68k@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k: Use generic strncpy_from_user(), strlen_user(), and strnlen_user()
References: <1338327216-15309-1-git-send-email-geert@linux-m68k.org>
	<20120530102226.GA28628@frolo.macqel>
	<CAMuHMdV5GVZR1BvGD3EncDFfPt=Bt9ndkKE8Mp7euE9KoSaGNQ@mail.gmail.com>
X-Yow: Is this TERMINAL fun?
Date: Wed, 30 May 2012 16:42:59 +0200
In-Reply-To: <CAMuHMdV5GVZR1BvGD3EncDFfPt=Bt9ndkKE8Mp7euE9KoSaGNQ@mail.gmail.com>
	(Geert Uytterhoeven's message of "Wed, 30 May 2012 13:20:02 +0200")
Message-ID: <m262bdbuh8.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> On Wed, May 30, 2012 at 12:22 PM, Philippe De Muyter <phdm@macqel.be> wrote:
>> On Tue, May 29, 2012 at 11:33:36PM +0200, Geert Uytterhoeven wrote:
>>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>> ---
>>> Do we also want
>>>
>>>     select HAVE_EFFICIENT_UNALIGNED_ACCESS if (!COLDFIRE && !M68000)
>>
>> Sorry, I did not follow what happened to unaligned accesses, but
>> CPU32 family (at least 68340) crashes on unaligned accesses.
>
> We don't seem to have CONFIG_M68340 in arch/m68k/Kconfig.cpu?

But we have CONFIG_MCPU32.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
