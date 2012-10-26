Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946009Ab2JZV3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 17:29:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45731 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab2JZV3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 17:29:14 -0400
Date: Fri, 26 Oct 2012 14:29:09 -0700
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] freezer: change ptrace_stop/do_signal_stop to use
 freezable_schedule()
Message-ID: <20121026212909.GW11442@htj.dyndns.org>
References: <20121023153919.GA16201@redhat.com>
 <20121026180149.GA22421@redhat.com>
 <2566006.UzAQbpOjNQ@vostro.rjw.lan>
 <2718983.vORnrfWdbE@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2718983.vORnrfWdbE@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Oct 26, 2012 at 11:29:56PM +0200, Rafael J. Wysocki wrote:
> Actually, what tree is it supposed to apply to?
> 
> The change in kernel/cgroup_freezer.c doesn't look like anything in
> the current Linus' tree to me.

Ooh, right.  This depends on the earlier cgroup_freezer changes.
Sorry about the confusion.  I'll apply it to the following branch (the
same one used for the previous cgroup_freezer updates).

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git cgroup-freezer

Thanks.

-- 
tejun
