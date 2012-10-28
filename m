Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab2J1AMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 20:12:18 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:41074 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab2J1AMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 20:12:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] freezer: change ptrace_stop/do_signal_stop to use freezable_schedule()
Date: Sun, 28 Oct 2012 02:16:15 +0200
Message-ID: <3398462.AB3BSRdprj@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.3-8-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121026212909.GW11442@htj.dyndns.org>
References: <20121023153919.GA16201@redhat.com> <2718983.vORnrfWdbE@vostro.rjw.lan> <20121026212909.GW11442@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 26, 2012 02:29:09 PM Tejun Heo wrote:
> Hello,
> 
> On Fri, Oct 26, 2012 at 11:29:56PM +0200, Rafael J. Wysocki wrote:
> > Actually, what tree is it supposed to apply to?
> > 
> > The change in kernel/cgroup_freezer.c doesn't look like anything in
> > the current Linus' tree to me.
> 
> Ooh, right.  This depends on the earlier cgroup_freezer changes.
> Sorry about the confusion.  I'll apply it to the following branch (the
> same one used for the previous cgroup_freezer updates).
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git cgroup-freezer

OK

I haven't merged it yet, so I'll get this fix along with the rest.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
