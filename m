Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab1BDQdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 11:33:10 -0500
Received: from brother.balabit.com ([195.70.62.219]:57946 "EHLO
	lists.balabit.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab1BDQdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 11:33:08 -0500
Subject: Re: CAP_SYSLOG, 2.6.38 and user space
From: Gergely Nagy <algernon@balabit.hu>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20110204160513.GB17396@mail.hallyn.com>
References: <1296733177.14846.26.camel@moria>
	 <20110203153252.GA24153@mail.hallyn.com>
	 <20110204160513.GB17396@mail.hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Feb 2011 17:33:06 +0100
Message-ID: <1296837186.24742.15.camel@moria>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-04 at 16:05 +0000, Serge E. Hallyn wrote:
> Quoting Serge E. Hallyn (serge@hallyn.com):
> > >From 2d7408541dd3a6e19a4265b028233789be6a40f4 Mon Sep 17 00:00:00 2001
> > From: Serge Hallyn <serge@peq.(none)>
> > Date: Thu, 3 Feb 2011 09:26:15 -0600
> > Subject: [PATCH 1/1] cap_syslog: don't refuse cap_sys_admin for now
> > 
> > At 2.6.39 or 2.6.40, let's add a sysctl which defaults to 0.  When
> > 0, refuse if cap_sys_admin, if 1, then allow.  This will allow
> > users to acknowledge (permanently, if they must, using /etc/sysctl.conf)
> > that they've seen the syslog message about cap_sys_admin being
> > deprecated for syslog.
> > 
> > Signed-off-by: Serge Hallyn <serge@hallyn.com>

[...snip...]

> James, do you mind taking this patch?

Would it be possible to change the commit message to say that 1 would be
the default? Just to avoid future confusion... (having it at 0 default
later would just postpone the userspace breakage)

-- 
|8]


