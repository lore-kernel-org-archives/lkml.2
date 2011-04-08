Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab1DHRl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 13:41:27 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:56050 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752899Ab1DHRlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:41:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lCOjdrBE7tVojz2oikNUeLDnrfwS9InVFoEgVR2fXeJ1A5N+uQ81DQPMiMsSlt/0n1KcXGDluqP4ioIu6vOSOUS0/iGU5E4jcjo/qU/0J8ioclbb4WZKVejDrMezw16D;
Date: Fri, 8 Apr 2011 10:41:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Matt Fleming <matt@console-pimps.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/8] kernel/signal.c: add kernel-doc notation to
 syscalls
Message-Id: <20110408104123.611e7a99.rdunlap@xenotime.net>
In-Reply-To: <20110405093214.0dd7278d@mfleming-mobl1.ger.corp.intel.com>
References: <20110404145803.8663081d.rdunlap@xenotime.net>
	<20110404150026.46478a04.rdunlap@xenotime.net>
	<20110405093214.0dd7278d@mfleming-mobl1.ger.corp.intel.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011 09:32:14 +0100 Matt Fleming wrote:

> On Mon, 4 Apr 2011 15:00:26 -0700
> Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
> > @@ -2660,6 +2708,13 @@ out:
> >  #endif /* __ARCH_WANT_SYS_SIGPROCMASK */
> >  
> >  #ifdef __ARCH_WANT_SYS_RT_SIGACTION
> > +/**
> > + *  sys_rt_sigaction - alter an action taken by a process
> > + *  @sig: signal to be sent
> > + *  @act: the thread group ID of the thread
> > + *  @oact: the PID of the thread
> > + *  @sigsetsize: size of sigset_t type
> > + */
> >  SYSCALL_DEFINE4(rt_sigaction, int, sig,
> >  		const struct sigaction __user *, act,
> >  		struct sigaction __user *, oact,
> 
> This isn't right. @act and @oct are the new and old actions for @sig.

Thanks.  I don't know how I did that.
I'll send a correction for it.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
