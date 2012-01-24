Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab2AXV7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 16:59:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab2AXV7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 16:59:21 -0500
Date: Tue, 24 Jan 2012 13:59:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
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
Message-Id: <20120124135914.dac98fb4.akpm@linux-foundation.org>
In-Reply-To: <20120124214630.GF2546@moon>
References: <20120124071716.GC29735@moon>
	<20120124162031.a3956058.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124073842.GE29735@moon>
	<20120124164008.aa1714bd.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124084823.GF29735@moon>
	<CAHGf_=r=zwj4=yjCekYZVRsTwjohJ8F8cP4rnZx6UL9kKNTc+g@mail.gmail.com>
	<20120124202606.GC2546@moon>
	<m18vkwj0dw.fsf@fess.ebiederm.org>
	<20120124205039.GB2278@moon>
	<20120124132222.d78bc0d4.akpm@linux-foundation.org>
	<20120124214630.GF2546@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jan 2012 01:46:30 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> > 
> > ENOENT seems inappropriate here.
> >
> 
> Which one should be better?

EINVAL, I guess.
