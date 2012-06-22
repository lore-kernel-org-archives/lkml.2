Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474Ab2FVL7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 07:59:11 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:37320 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760258Ab2FVL7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 07:59:09 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k: remove never used asm/shm.h
References: <1340361221.1773.78.camel@x61.thuisdomein>
X-Yow: Where do your SOCKS go when you lose them in th' WASHER?
Date: Fri, 22 Jun 2012 13:59:03 +0200
In-Reply-To: <1340361221.1773.78.camel@x61.thuisdomein> (Paul Bolle's message
	of "Fri, 22 Jun 2012 12:33:41 +0200")
Message-ID: <m2txy3imm0.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle <pebolle@tiscali.nl> writes:

> m68k's asm/shm.h header has been part of the tree ever since m68k
> support got added in v1.3.94. (It started as /include/asm-m68k/shm.h and
> moved to its current location a few years ago.) It seems it was never
> used: no file ever included it and nothing used the macros it defines.

Apparently this was a precursor to what is now <asm/shmparam.h> (which
was introduced in 1.3.2).

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
