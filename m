Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1B1Umb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 15:42:31 -0500
Received: from www.tglx.de ([62.245.132.106]:59936 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab1B1Umb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 15:42:31 -0500
Date: Mon, 28 Feb 2011 21:42:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Taking forward the realtime work
In-Reply-To: <4D691ACA.9090405@gmail.com>
Message-ID: <alpine.LFD.2.00.1102282140540.2701@localhost6.localdomain6>
References: <4D691ACA.9090405@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maarten,

On Sat, 26 Feb 2011, Maarten Lankhorst wrote:

> Hi all,
> 
> After digging through the -rt patchset again I wanted to take it forward to
> the current kernel, so far I didn't to get much work done as the code seems to
> be kinda invasive, even with a lot of the things already in mainline. However
> a lot of things in the -rt patch seem to no longer be needed, since softirqs
> are merged, the BKL is gone, and there's a patch set out to make mm
> preemptible.
> 
> I've started testing from the mm-preempt patchset, and it seems to boot, but
> now that I'm actually looking at the -rt patchset diff from v2.6.33.7 it's not
> that trivial to port forward, so I'm looking for help. Blindly trying to apply
> the diff forward 6 versions will not work, so I'm looking at how to add the
> patches in such a way that each change is done in a logical order, in such a
> way preferably that at each point the kernel is bootable. I understand that
> for -rt there will be a few commits for which that won't be possible, but it
> seems to me the amount of work needed to get -rt working isn't as big any more
> as it used to be.
> 
> Note: There's no guarantee I'll be able to pull it off, but there's this itch
> I need to get rid of. ;)

Note: It would be nice to Cc those who are working on it and I can
assure you that there will be an update to -rt in the foreseeable
future.

Thanks,

	tglx
