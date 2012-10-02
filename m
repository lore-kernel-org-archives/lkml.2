Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab2JBLZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:25:53 -0400
Received: from tundra.namei.org ([65.99.196.166]:58668 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab2JBLZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:25:52 -0400
Date: Tue, 2 Oct 2012 21:23:41 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Andy Lutomirski <luto@amacapital.net>
cc: James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org,
        Will Drewry <wad@chromium.org>, x86@kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 resend] seccomp: Make syscall skipping and nr changes
 more consistent
In-Reply-To: <1c47b77bc4f572e9f9755b7bbccef045ee451a1b.1349116571.git.luto@amacapital.net>
Message-ID: <alpine.LRH.2.02.1210022122240.15182@tundra.namei.org>
References: <1c47b77bc4f572e9f9755b7bbccef045ee451a1b.1349116571.git.luto@amacapital.net>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2012, Andy Lutomirski wrote:

> This fixes two issues that could cause incompatibility between
> kernel versions:
> 
>  - If a tracer uses SECCOMP_RET_TRACE to select a syscall number
>    higher than the largest known syscall, emulate the unknown
>    vsyscall by returning -ENOSYS.  (This is unlikely to make a
>    noticeable difference on x86-64 due to the way the system call
>    entry works.)
> 
>  - On x86-64 with vsyscall=emulate, skipped vsyscalls were buggy.
> 
> This updates the documentation accordingly.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> Acked-by: Will Drewry <wad@chromium.org>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next-queue

