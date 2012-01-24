Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab2AXU0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 15:26:15 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61493 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab2AXU0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 15:26:13 -0500
Date: Wed, 25 Jan 2012 00:26:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
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
Message-ID: <20120124202606.GC2546@moon>
References: <20120123142436.258631438@openvz.org>
 <20120124111655.b29264d2.kamezawa.hiroyu@jp.fujitsu.com>
 <20120124064719.GA29735@moon>
 <4F1E57F3.6020607@zytor.com>
 <20120124071716.GC29735@moon>
 <20120124162031.a3956058.kamezawa.hiroyu@jp.fujitsu.com>
 <20120124073842.GE29735@moon>
 <20120124164008.aa1714bd.kamezawa.hiroyu@jp.fujitsu.com>
 <20120124084823.GF29735@moon>
 <CAHGf_=r=zwj4=yjCekYZVRsTwjohJ8F8cP4rnZx6UL9kKNTc+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHGf_=r=zwj4=yjCekYZVRsTwjohJ8F8cP4rnZx6UL9kKNTc+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 03:20:26PM -0500, KOSAKI Motohiro wrote:
> >> please do as you like.
> >
> > So it should be something like below I think...
> 
> Looks ok this version to me. So, if you fix other developers pointed
> issue, I'll ack this.
> 

Thanks!

Eric, so mm/ would be fine or I still should move it to kernel/
instead? I've addressed other issues I hope.

	Cyrill
