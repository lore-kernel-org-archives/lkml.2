Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab0LQUWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:22:01 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:51962
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753020Ab0LQUV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:21:58 -0500
Date: Fri, 17 Dec 2010 20:22:19 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <michael.kerrisk@gmail.com>
Subject: Re: [RFC 4/5] user namespaces: allow killing tasks in your own or
 child userns
Message-ID: <20101217202219.GA15926@mail.hallyn.com>
References: <20101217152246.GA8221@mail.hallyn.com>
 <20101217152458.GA11162@mail.hallyn.com>
 <20101217152547.GB11162@mail.hallyn.com>
 <20101217152625.GC11162@mail.hallyn.com>
 <20101217152659.GD11162@mail.hallyn.com>
 <m14oacryar.fsf@fess.ebiederm.org>
 <20101217200903.GA15528@mail.hallyn.com>
 <m1d3p0qhl5.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d3p0qhl5.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> >> >  	cred = current_cred();
> >> >  	tcred = __task_cred(t);
> >> Nit pick  you don't need to compute cred and tcred here now.
> >
> > Just to make sure I understand right: you mean wait until after the
> > same_thread_group() check to save calculation in that case, right?
> 
> I mean cred and tcred are only use in kill_ok_by_cred.
> So we can eliminate those two variables from check_kill_permission.

D'oh.  Should've looked at the original tree, not the context.  Got it,
thanks.

-serge
