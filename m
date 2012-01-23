Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2AWD3E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 22:29:04 -0500
Received: from tundra.namei.org ([65.99.196.166]:41764 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab2AWD3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 22:29:02 -0500
Date: Mon, 23 Jan 2012 14:28:50 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        David Howells <dhowells@redhat.com>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT] More security subsystem fixes
In-Reply-To: <201201192321.AIB12409.LOJQOOMtVSFFFH@I-love.SAKURA.ne.jp>
Message-ID: <alpine.LRH.2.00.1201231428120.22633@tundra.namei.org>
References: <alpine.LRH.2.00.1201191631040.31730@tundra.namei.org> <201201190620.q0J6KMvA047997@www262.sakura.ne.jp> <201201192321.AIB12409.LOJQOOMtVSFFFH@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jan 2012, Tetsuo Handa wrote:

> mpi_limb_t
> mpihelp_divrem(mpi_ptr_t qp, mpi_size_t qextra_limbs,
>                mpi_ptr_t np, mpi_size_t nsize, mpi_ptr_t dp, mpi_size_t dsize)
> {
>         mpi_limb_t most_significant_q_limb = 0;
> 
>         switch (dsize) {
>         case 0:
>                 /* We are asked to divide by zero, so go ahead and do it!  (To make
>                    the compiler not remove this statement, return the value.)  */
>                 return 1 / dsize;
> 
> What's this? Division by 0 in the kernel is no good.

David,

Do you know if this is triggerable from userland?


- James
-- 
James Morris
<jmorris@namei.org>
