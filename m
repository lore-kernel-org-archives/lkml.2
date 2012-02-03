Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2BCJW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:22:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab2BCJWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:22:24 -0500
Date: Fri, 3 Feb 2012 01:22:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch cr 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
Message-Id: <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
In-Reply-To: <20120203090929.GA23996@elte.hu>
References: <20120130140905.441199885@openvz.org>
	<20120130141852.309402052@openvz.org>
	<20120203074656.GC30543@elte.hu>
	<20120203083530.GD1968@moon>
	<20120203090929.GA23996@elte.hu>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Feb 2012 10:09:29 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> > > > +			get_random_bytes(&cookies[i][j],
> > > > +					 sizeof(cookies[i][j]));
> > > 
> > > ugly line break.
> > > 
> > 
> > Why? Looks pretty good to me. But sure I'll change it.
> 
> It's ugly because it serves no purpose other than pacifying 
> checkpatch and makes the code *uglier*.

No it doesn't.  For 80-col displays the code is *already wrapped*.  And
that wrapping to column 0 is vastly worse than the above.

If we want to increase the standard to (say) 96 cols then fine, I'd be
happy with that.  But until we do that we should not create such a
gruesome mess for those who use 80 cols.

> It's a disease. When checkpatch tells you "this line is too 
> long" then consider it a code cleanliness warning!

Well yes, if it can be fixed by other means then great.

