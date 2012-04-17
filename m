Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab2DQBdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 21:33:45 -0400
Received: from tundra.namei.org ([65.99.196.166]:57963 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab2DQBdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 21:33:43 -0400
Date: Tue, 17 Apr 2012 11:33:26 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Will Drewry <wad@chromium.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Eric Paris <eparis@redhat.com>, Kees Cook <keescook@chromium.org>
Subject: Re: linux-next: build failure after merge of the final tree (security
 tree related)
In-Reply-To: <CABqD9hYhC3dNX3CVSbsuJaG=zBUC4VMyMVYYmyOTN+Xfb=uC8w@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1204171127130.14814@tundra.namei.org>
References: <20120416154607.302f7ae245472e1e917dacef@canb.auug.org.au> <CABqD9hauxzd4vVbxyC5M1p9e6mLt1cjYP7wbhzTKPi3iMpc0kg@mail.gmail.com> <CABqD9hYhC3dNX3CVSbsuJaG=zBUC4VMyMVYYmyOTN+Xfb=uC8w@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012, Will Drewry wrote:

> >> arch/powerpc/kernel/ptrace.c: In function 'do_syscall_trace_enter':
> >> arch/powerpc/kernel/ptrace.c:1713:2: error: statement with no effect [-Werror=unused-value]
> >> cc1: all warnings being treated as errors

Is this happening because of

	#define secure_computing(x) 0

?

In any case, that should probably be a static inline.


- James
-- 
James Morris
<jmorris@namei.org>
