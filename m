Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908Ab2DKSiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:38:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137Ab2DKSiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:38:24 -0400
Date: Wed, 11 Apr 2012 20:31:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
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
Message-ID: <20120411183132.GA22007@redhat.com>
References: <20120215160652.GA17680@redhat.com> <20120215162752.GF4533@moon> <20120409151027.7f3e0fa5.akpm@linux-foundation.org> <20120409222443.GW1625@moon> <4F836F3E.9090207@zytor.com> <20120410223758.GL24857@moon> <20120410230833.GA17620@redhat.com> <4F84C2FA.8090703@zytor.com> <20120410234206.GA19251@redhat.com> <20120411063957.GA11629@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411063957.GA11629@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11, Cyrill Gorcunov wrote:
>
> On Wed, Apr 11, 2012 at 01:42:06AM +0200, Oleg Nesterov wrote:
> > OK, I am not arguing. Just I thought that the small note like
> > "we are doing this per-type to obfuscate even more" can help.
> > I wouldn't have asked, but Cyrill rewrites this comment anyway.
> >
> > Perhaps this is just me, but my first (and wrong) impression was
> > that somehow this is needed for correctness.
>
> Hi Oleg, would the form below sounds good?

Sure, thanks.

Oleg.

