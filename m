Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2BCHJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:09:14 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56972 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2BCHJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:09:12 -0500
Date: Fri, 3 Feb 2012 11:09:05 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch cr 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
Message-ID: <20120203070905.GA1968@moon>
References: <20120130140905.441199885@openvz.org>
 <20120130141852.309402052@openvz.org>
 <20120202152632.c356719a.akpm@linux-foundation.org>
 <4F2B45F6.7020704@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2B45F6.7020704@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 06:27:02PM -0800, H. Peter Anvin wrote:
> On 02/02/2012 03:26 PM, Andrew Morton wrote:
> >>
> >>--- linux-2.6.git.orig/kernel/Makefile
> >>+++ linux-2.6.git/kernel/Makefile
> >>@@ -25,6 +25,7 @@ endif
> >>  obj-y += sched/
> >>  obj-y += power/
> >>
> >>+obj-$(CONFIG_X86) += kcmp.o
> >
> >Can we turn this into obj-$(CONFIG_CHECKPOINT_RESTART) and add the
> >cond_syscall to sys_ni.c?
> >
> >I keep saying this, because "hey, we can delete it all again" figures
> >largely in my rationale for merging your code ;)
> >
> 
> Ah, yes please.
> 

Sure, will update, thanks!

	Cyrill
