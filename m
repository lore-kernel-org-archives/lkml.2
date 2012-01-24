Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab2AXUUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 15:20:49 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56374 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356Ab2AXUUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 15:20:47 -0500
MIME-Version: 1.0
In-Reply-To: <20120124084823.GF29735@moon>
References: <20120123142036.025893883@openvz.org> <20120123142436.258631438@openvz.org>
 <20120124111655.b29264d2.kamezawa.hiroyu@jp.fujitsu.com> <20120124064719.GA29735@moon>
 <4F1E57F3.6020607@zytor.com> <20120124071716.GC29735@moon>
 <20120124162031.a3956058.kamezawa.hiroyu@jp.fujitsu.com> <20120124073842.GE29735@moon>
 <20120124164008.aa1714bd.kamezawa.hiroyu@jp.fujitsu.com> <20120124084823.GF29735@moon>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 24 Jan 2012 15:20:26 -0500
Message-ID: <CAHGf_=r=zwj4=yjCekYZVRsTwjohJ8F8cP4rnZx6UL9kKNTc+g@mail.gmail.com>
Subject: Re: [patch 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v4
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> please do as you like.
>
> So it should be something like below I think...

Looks ok this version to me. So, if you fix other developers pointed
issue, I'll ack this.

thanks.
