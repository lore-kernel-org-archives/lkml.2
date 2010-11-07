Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab0KGXDJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 18:03:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42199 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab0KGXDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 18:03:08 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Jim <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling  drivers/char/i8k.c ?
References: <4CD538CA.8010901@xs4all.nl> <87wroostw3.fsf@basil.nowhere.org>
	<m2hbfsu57i.fsf@igel.home>
Date: Mon, 08 Nov 2010 00:03:02 +0100
In-Reply-To: <m2hbfsu57i.fsf@igel.home> (Andreas Schwab's message of "Sun, 07
	Nov 2010 23:41:37 +0100")
Message-ID: <87k4kospnd.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab <schwab@linux-m68k.org> writes:
>
> The asm fails to mention that it modifies *regs.

It has a memory clobber, that should be enough, no?

Besides in any case it cannot be eliminated because it has
valid non dead inputs and outputs.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
