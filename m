Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab2DQDZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 23:25:36 -0400
Received: from tundra.namei.org ([65.99.196.166]:53026 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945Ab2DQDZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 23:25:34 -0400
Date: Tue, 17 Apr 2012 13:25:18 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Will Drewry <wad@chromium.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Eric Paris <eparis@redhat.com>, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] seccomp: use a static inline for a function stub
In-Reply-To: <20120417120848.e7f3eabfbf79dc609318ea1e@canb.auug.org.au>
Message-ID: <alpine.LRH.2.02.1204171325020.15355@tundra.namei.org>
References: <20120417120848.e7f3eabfbf79dc609318ea1e@canb.auug.org.au>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012, Stephen Rothwell wrote:

> Fixes this error message when CONFIG_SECCOMP is not set:
> 
> arch/powerpc/kernel/ptrace.c: In function 'do_syscall_trace_enter':
> arch/powerpc/kernel/ptrace.c:1713:2: error: statement with no effect [-Werror=unused-value]
> 
> Signed-off-by: Stephen Rothwell <sfr@ozlabs.au.ibm.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next


-- 
James Morris
<jmorris@namei.org>
