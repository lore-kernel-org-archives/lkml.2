Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab2DGKKw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 06:10:52 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:57556 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab2DGKKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 06:10:51 -0400
Date: Sat, 7 Apr 2012 12:10:39 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH v2] avr32: fix nop compile fails from system.h split up
Message-ID: <20120407101039.GA10112@samfundet.no>
References: <1333494844-3802-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333494844-3802-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Tue 03 Apr 2012 19:14:04 -0400 or thereabout, Paul Gortmaker wrote:
> To fix:
> 
>   In file included from kernel/exit.c:61:
>   arch/avr32/include/asm/mmu_context.h: In function 'enable_mmu':
>   arch/avr32/include/asm/mmu_context.h:135: error: implicit
>   declaration of function 'nop'
> 
> It needs an include of the new file created in:
> 
> commit ae473946586680b01c13975a3b674de23ad7c93e
> 
>     "Disintegrate asm/system.h for AVR32"
> 
> But since that file only contains "nop", and since other
> arch already have precedent of putting nop in asm/barrier.h
> we should just delete the new file and put nop in barrier.h

Sounds fine by me, thanks for the fix.

> Suggested-by: David Howells <dhowells@redhat.com>
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt
