Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707Ab2DJXnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 19:43:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab2DJXnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 19:43:41 -0400
Date: Wed, 11 Apr 2012 01:42:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Message-ID: <20120410234206.GA19251@redhat.com>
References: <20120215143606.GA14037@redhat.com> <20120215160652.GA17680@redhat.com> <20120215162752.GF4533@moon> <20120409151027.7f3e0fa5.akpm@linux-foundation.org> <20120409222443.GW1625@moon> <4F836F3E.9090207@zytor.com> <20120410223758.GL24857@moon> <20120410230833.GA17620@redhat.com> <4F84C2FA.8090703@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F84C2FA.8090703@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10, H. Peter Anvin wrote:
>
> On 04/10/2012 04:08 PM, Oleg Nesterov wrote:
> >
> > OK, since this is discussed again...
> >
> > Can this comment can also explain why do we obfuscate the pointers
> > by type? I mean, I don't really understand why the one-dimensional
> > cookies[2] is "not enough" from security pov.
>
> Because it's cheap.  "Just enough" is not what you want to shoot for,
> ever, you want to get past the "just enough" point and then consider
> "what can I get for cheap at this point"?

OK, I am not arguing. Just I thought that the small note like
"we are doing this per-type to obfuscate even more" can help.
I wouldn't have asked, but Cyrill rewrites this comment anyway.

Perhaps this is just me, but my first (and wrong) impression was
that somehow this is needed for correctness.

Oleg.

