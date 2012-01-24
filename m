Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab2AXVeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 16:34:17 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51500 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab2AXVeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 16:34:15 -0500
Date: Wed, 25 Jan 2012 01:34:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
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
Message-ID: <20120124213409.GE2546@moon>
References: <20120124071716.GC29735@moon>
 <20120124162031.a3956058.kamezawa.hiroyu@jp.fujitsu.com>
 <20120124073842.GE29735@moon>
 <20120124164008.aa1714bd.kamezawa.hiroyu@jp.fujitsu.com>
 <20120124084823.GF29735@moon>
 <CAHGf_=r=zwj4=yjCekYZVRsTwjohJ8F8cP4rnZx6UL9kKNTc+g@mail.gmail.com>
 <20120124202606.GC2546@moon>
 <m18vkwj0dw.fsf@fess.ebiederm.org>
 <20120124205039.GB2278@moon>
 <m1ty3khk6r.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ty3khk6r.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 01:20:12PM -0800, Eric W. Biederman wrote:
...
> >
> > This one should fit all requirements I guess.
> 
> Bahahaha!
> 
> Looking I see one  more nit.
> 
> You need an entry in include/linux/syscalls.h

Sigh.. ;) Not just this. I'll post updated version to address
Andrew's comments too once I finish it (not today probably).

	Cyrill
