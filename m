Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab1ALJ0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 04:26:34 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:58661 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab1ALJ02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 04:26:28 -0500
Date: Wed, 12 Jan 2011 14:56:24 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
Message-ID: <20110112092624.GH2723@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <1294657154.2016.459.camel@laptop>
 <1294677746.8345.4.camel@marge.simson.net>
 <20110111171046.GL4772@in.ibm.com>
 <1294771686.8006.15.camel@marge.simson.net>
 <20110112033709.GA2723@in.ibm.com>
 <AANLkTikFGqznUg7bzFckJy_x2mfBqE7PjaK2n83wLk6c@mail.gmail.com>
 <20110112063543.GD2723@in.ibm.com>
 <1294817081.8370.60.camel@marge.simson.net>
 <20110112080620.GG2723@in.ibm.com>
 <1294822039.8370.97.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294822039.8370.97.camel@marge.simson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 09:47:19AM +0100, Mike Galbraith wrote:
> On Wed, 2011-01-12 at 13:36 +0530, Bharata B Rao wrote:
> > On Wed, Jan 12, 2011 at 08:24:41AM +0100, Mike Galbraith wrote:
> 
> > > Yes, it's supposed to be transparent to cgroups.
> > 
> > If cgroups doesn't want that task and if its transparent to cgroups,
> > why is it shown as part of /cgroups/tasks ? The task really doesn't
> > belong in there. Its not on the runqueue of root_task_group.
> > 
> > So basically I feel that a task consumed by autogroup shouldn't ideally be
> > shown in root cgroup's tasks file.
> 
> >From cgroups' viewpoint, root is where it's at.  The task isn't consumed
> by autogroup either, it's only borrowed until cgroups claims it.
> 
> Would you prefer that when you mount /cgroups, you see a nearly empty
> root task list because box was booted with autogroup enabled?

If I had my way, I would say yes :) I would even say make autogroups visible
so that we know exactly what it is. Let 'auto' in autogroups mean only
'automatic' and not necessarily 'hidden'.

> Should
> tasks appear and disappear on the fly while you're watching?

Why would they unless we explicitly move them ?

Anyway I guess you would have gone through these questions already.
Thanks for patiently answering :)

Regards,
Bharata.
