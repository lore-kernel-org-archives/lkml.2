Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab2JAJgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 05:36:45 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43137 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab2JAJgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 05:36:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120731192808.769449391@chello.nl>
References: <20120731191204.540691987@chello.nl> <20120731192808.769449391@chello.nl>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Mon, 1 Oct 2012 11:36:22 +0200
X-Google-Sender-Auth: 4XxWYQZGiu47hZBKL2qLNWciyS8
Message-ID: <CAHO5Pa2Ai6BzXFtTDBzuw4y=tzk9G4DA=9cRBojVjjMB9mtT0w@mail.gmail.com>
Subject: Re: [PATCH 07/19] mm/mpol: Add MPOL_MF_NOOP
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@kernel.org, riel@redhat.com, oleg@redhat.com, pjt@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, Lee.Schermerhorn@hp.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 9:12 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> From: Lee Schermerhorn <lee.schermerhorn@hp.com>
>
> This patch augments the MPOL_MF_LAZY feature by adding a "NOOP"
> policy to mbind().  When the NOOP policy is used with the 'MOVE
> and 'LAZY flags, mbind() [check_range()] will walk the specified
> range and unmap eligible pages so that they will be migrated on
> next touch.

This patch is mistitled. The new flag is MPOL_NOOP. That made it
difficult to find the commit in linux-next. Does it make sense to fix
the patch title before this hits mainline?

Thanks,

Michael



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
