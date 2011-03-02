Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1CBNkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 08:40:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710Ab1CBNkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 08:40:41 -0500
Date: Wed, 2 Mar 2011 14:32:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Indan Zupancic <indan@nul.nu>, Denys Vlasenko <vda.linux@googlemail.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org,
        Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110302133206.GA9838@redhat.com>
References: <20110301152457.GE26074@htj.dyndns.org> <201103011757.48593.vda.linux@googlemail.com> <20110301170953.GB17933@htj.dyndns.org> <AANLkTi=8=Tw2aYzvwM_s8dsMmw3W_tYjsYkqTHS9moUW@mail.gmail.com> <20110301183454.GC23527@mtj.dyndns.org> <830cc1666bd4a610d5e870218f06bd2d.squirrel@webmail.greenhost.nl> <20110302074447.GE19669@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302074447.GE19669@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02, Tejun Heo wrote:
>
> On Wed, Mar 02, 2011 at 06:07:35AM +0100, Indan Zupancic wrote:
> > I'm not sure what Denys is talking about: Currently it's impossible to
> > pass along SIGSTOP to traced processes. Quoting the ptrace manpage:
> >
> >    PTRACE_CONT
> >           Restarts  the stopped child process.  If data is nonzero and not
> >           SIGSTOP, it is interpreted as a signal to be  delivered  to  the
> >           child;  otherwise,  no  signal is delivered.
>
> AFAICS, that's not true.  SIGSTOP isn't treated differently from other
> signals in the ptrace signal delivery path.  Maybe it was true in the
> past.

Yes, this is not true. And it seems this was never true.

This is the second time this manpage confuses people in this discussion,
probably it should be fixed...

Add Michael.

Oleg.

