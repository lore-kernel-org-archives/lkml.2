Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab1ETVBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 17:01:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43826 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab1ETVA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 17:00:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: PM: Remove sysdev suspend, resume and shutdown operations
Date: Fri, 20 May 2011 22:29:04 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        git-commits-head@vger.kernel.org
References: <201105200000.p4K00YYZ026097@hera.kernel.org> <1305868017.7481.144.camel@pasglop>
In-Reply-To: <1305868017.7481.144.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105202229.04984.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 20, 2011, Benjamin Herrenschmidt wrote:
> On Fri, 2011-05-20 at 00:00 +0000, Linux Kernel Mailing List wrote:
> > Gitweb:     http://git.kernel.org/linus/2e711c04dbbf7a7732a3f7073b1fc285d12b369d
> > Commit:     2e711c04dbbf7a7732a3f7073b1fc285d12b369d
> > Parent:     f5a592f7d74e38c5007876c731e6bf5580072e63
> > Author:     Rafael J. Wysocki <rjw@sisk.pl>
> > AuthorDate: Tue Apr 26 19:15:07 2011 +0200
> > Committer:  Rafael J. Wysocki <rjw@sisk.pl>
> > CommitDate: Wed May 11 21:37:15 2011 +0200
> > 
> >     PM: Remove sysdev suspend, resume and shutdown operations
> >     
> >     Since suspend, resume and shutdown operations in struct sysdev_class
> >     and struct sysdev_driver are not used any more, remove them.  Also
> >     drop sysdev_suspend(), sysdev_resume() and sysdev_shutdown() used
> >     for executing those operations and modify all of their users
> >     accordingly.  This reduces kernel code size quite a bit and reduces
> >     its complexity.
> 
> Your grep is broken ? :-)

Apparently, it is ...

> You forgot drivers/macintosh/via-pmu.c ... I'll stick a fix in powerpc
> before I send to Linus later today.

Many thanks and sorry for the trouble.

Rafael
