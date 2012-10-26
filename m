Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966624Ab2JZV0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 17:26:01 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:40204 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965612Ab2JZVZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 17:25:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] freezer: change ptrace_stop/do_signal_stop to use freezable_schedule()
Date: Fri, 26 Oct 2012 23:29:56 +0200
Message-ID: <2718983.vORnrfWdbE@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.3-8-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <2566006.UzAQbpOjNQ@vostro.rjw.lan>
References: <20121023153919.GA16201@redhat.com> <20121026180149.GA22421@redhat.com> <2566006.UzAQbpOjNQ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 26, 2012 11:14:17 PM Rafael J. Wysocki wrote:
> On Friday, October 26, 2012 08:01:49 PM Oleg Nesterov wrote:
> > On 10/26, Tejun Heo wrote:
> > >
> > >  Acked-by: Tejun Heo <tj@kernel.org>
> > 
> > Thanks!
> > 
> > > Rafael, sorry that this one doesn't have pm cc'd
> > 
> > Ah, sorry Rafael. Yes, I have read you email, and I was going to
> > add linux-pm but forgot.
> > 
> > > but can you please
> > > pick up this one too?
> > 
> > Please, and thanks.
> 
> OK, but that will go to Linus in the next batch.

Actually, what tree is it supposed to apply to?

The change in kernel/cgroup_freezer.c doesn't look like anything in
the current Linus' tree to me.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
