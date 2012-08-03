Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab2HCEj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 00:39:29 -0400
Received: from tundra.namei.org ([65.99.196.166]:40510 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab2HCEj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 00:39:28 -0400
Date: Fri, 3 Aug 2012 14:36:55 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Andy Lutomirski <luto@amacapital.net>
cc: James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org,
        Will Drewry <wad@chromium.org>, x86@kernel.org
Subject: Re: [PATCH v2] seccomp: Make syscall skipping and nr changes more
 consistent
In-Reply-To: <744e07394a02be3d3ef52c22ccedb24d9a478fe1.1343869850.git.luto@amacapital.net>
Message-ID: <alpine.LRH.2.02.1208031435550.25196@tundra.namei.org>
References: <744e07394a02be3d3ef52c22ccedb24d9a478fe1.1343869850.git.luto@amacapital.net>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2012, Andy Lutomirski wrote:

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

Please rebase this to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next

or wait until the next -rc, where I'll sync with Linus.

-- 
James Morris
<jmorris@namei.org>
