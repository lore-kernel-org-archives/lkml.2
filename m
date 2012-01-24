Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab2AXVbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 16:31:12 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48491 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab2AXVbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 16:31:11 -0500
Date: Wed, 25 Jan 2012 01:31:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v4
Message-ID: <20120124213104.GD2546@moon>
References: <20120124071716.GC29735@moon>
 <20120124162031.a3956058.kamezawa.hiroyu@jp.fujitsu.com>
 <20120124073842.GE29735@moon>
 <20120124164008.aa1714bd.kamezawa.hiroyu@jp.fujitsu.com>
 <20120124084823.GF29735@moon>
 <CAHGf_=r=zwj4=yjCekYZVRsTwjohJ8F8cP4rnZx6UL9kKNTc+g@mail.gmail.com>
 <20120124202606.GC2546@moon>
 <m18vkwj0dw.fsf@fess.ebiederm.org>
 <20120124205039.GB2278@moon>
 <20120124132516.34abfac1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124132516.34abfac1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 01:25:16PM -0800, Andrew Morton wrote:
> On Wed, 25 Jan 2012 00:50:39 +0400
> Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > While doing the checkpoint-restore in the userspace
> 
> btw, some questions regarding the overall project: do you guys actually
> have working userspace code which can at least partially perform a c/r?
> What state is all this in?
> 

Yes, we have a number of test-cases which do c/r. See details on
http://criu.org/ . We don't announce it yet since everything is under
heavy development.

> I'd be a bit concerned if we're putting code into mainline which has
> not been demonstrated to achieve any form of successful checkpoint/restore.

	Cyrill
