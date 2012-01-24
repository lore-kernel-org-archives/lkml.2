Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab2AXWyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:54:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab2AXWyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:54:05 -0500
Date: Tue, 24 Jan 2012 14:54:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
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
Message-Id: <20120124145403.39972882.akpm@linux-foundation.org>
In-Reply-To: <m1ty3kg19h.fsf@fess.ebiederm.org>
References: <20120124064719.GA29735@moon>
	<4F1E57F3.6020607@zytor.com>
	<20120124071716.GC29735@moon>
	<20120124162031.a3956058.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124073842.GE29735@moon>
	<20120124164008.aa1714bd.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124084823.GF29735@moon>
	<CAHGf_=r=zwj4=yjCekYZVRsTwjohJ8F8cP4rnZx6UL9kKNTc+g@mail.gmail.com>
	<20120124202606.GC2546@moon>
	<m18vkwj0dw.fsf@fess.ebiederm.org>
	<20120124205039.GB2278@moon>
	<20120124132222.d78bc0d4.akpm@linux-foundation.org>
	<m1ty3kg19h.fsf@fess.ebiederm.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jan 2012 14:54:18 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Simply open coding the comparison would be better. 
> 
>         ret = kcmp_ptr(task1->files, task2->files, type);

yup, that's nice.
