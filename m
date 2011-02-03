Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab1BCRH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:07:29 -0500
Received: from brother.balabit.com ([195.70.62.219]:45880 "EHLO
	lists.balabit.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552Ab1BCRH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:07:28 -0500
Subject: Re: CAP_SYSLOG, 2.6.38 and user space
From: Gergely Nagy <algernon@balabit.hu>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
In-Reply-To: <20110203165132.GA28172@mail.hallyn.com>
References: <1296733177.14846.26.camel@moria>
	 <20110203153252.GA24153@mail.hallyn.com> <1296748401.14846.39.camel@moria>
	 <20110203165132.GA28172@mail.hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Feb 2011 18:07:26 +0100
Message-ID: <1296752846.14846.45.camel@moria>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 16:51 +0000, Serge E. Hallyn wrote:
> > > The idea would be to only use both when you detect a possibly older
> > > kernel. 
> > 
> > I was considering that, but... how do I reliably detect an older kernel?
> > So far, I didn't find a reliable way with which I can detect a kernel
> > version at run-time (apart from parsing utsname)
> 
> ...  Why not parse utsname?

It looks like an ugly hack to me. Apart from that, I can't list anything
against it.

On the other hand, the sysctl is a much better idea, I'd say, and having
that means one doesn't have to parse utsname either.

> > > From 2d7408541dd3a6e19a4265b028233789be6a40f4 Mon Sep 17 00:00:00 2001
> > > From: Serge Hallyn <serge@peq.(none)>
> > > Date: Thu, 3 Feb 2011 09:26:15 -0600
> > > Subject: [PATCH 1/1] cap_syslog: don't refuse cap_sys_admin for now
> > > 
> > > At 2.6.39 or 2.6.40, let's add a sysctl which defaults to 0.  When
> > > 0, refuse if cap_sys_admin, if 1, then allow.  This will allow
> > > users to acknowledge (permanently, if they must, using /etc/sysctl.conf)
> > > that they've seen the syslog message about cap_sys_admin being
> > > deprecated for syslog.
> > 
> > Could we have it the other way around, at least for a while? Otherwise,
> 
> Sure.
> 
> So long as there is a definite path toward eventually having syslog
> with CAP_SYS_ADMIN be denied.

\o/

-- 
|8]


