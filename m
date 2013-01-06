Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab3AFWWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 17:22:25 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:33632 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab3AFWWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 17:22:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-pm@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 0/1] Delete legacy power trace API
Date: Sun, 06 Jan 2013 23:28:03 +0100
Message-ID: <6941120.WfD5vZUxk3@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357510436.10284.69.camel@gandalf.local.home>
References: <1357350544-32704-1-git-send-email-paul.gortmaker@windriver.com> <5190666.Mu6UtpjCCL@vostro.rjw.lan> <1357510436.10284.69.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 06, 2013 05:13:56 PM Steven Rostedt wrote:
> On Sat, 2013-01-05 at 23:10 +0100, Rafael J. Wysocki wrote:
> > On Friday, January 04, 2013 08:49:03 PM Paul Gortmaker wrote:
> > > The actual deletion is mind-numbingly simple; and if you go by the
> > > comments in the code, it is well overdue.  However, in discussions
> > > with Frederic, he suggested to me that those comments might have
> > > been overly optimistic, and that there may still be people out
> > > there who are still unknowingly using this dead API.
> > > 
> > > So, that is the crux of the RFC component -- to check whether the
> > > comments saying "delete by v3.1" can be taken at face value, or
> > > whether they were overly optimistic, and hence this stuff is still
> > > actively used even though it is overdue for deletion.
> > 
> > Do you want me or the tracing maintainers to handle this?
> > 
> 
> You can take it. If you want you can add:
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

Cool, that helps. :-)

I'll take it.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
