Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0LIOUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 09:20:36 -0500
Received: from www.tglx.de ([62.245.132.106]:59308 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab0LIOUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 09:20:34 -0500
Date: Thu, 9 Dec 2010 15:18:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv1 000/211] unicore32 architecture support
In-Reply-To: <4D00E212.9080001@kernel.org>
Message-ID: <alpine.LFD.2.00.1012091516240.2653@localhost6.localdomain6>
References: <01ca01cb9783$7818c3f0$684a4bd0$@mprc.pku.edu.cn> <4D00A672.9050906@kernel.org> <alpine.LFD.2.00.1012091443580.2653@localhost6.localdomain6> <4D00E212.9080001@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Dec 2010, Tejun Heo wrote:

> On 12/09/2010 02:49 PM, Thomas Gleixner wrote:
> >> * Patches should be split according to logical steps of changes, not
> >>   per-file.
> >>
> >> * Patches should be bisectable.  IOW, after applying upto any patch in
> >>   the series, the tree should be buildable and working.
> > 
> > That does not work for a new architecture. There is nothing to bisect.
> 
> Sure, but at least it shouldn't introduce build scripts first which
> wouldn't work at all.
> 
> >> * When posting a patch series, especially one as large as 211, please
> >>   make the mails for the actual patches replies to the head message.
> >>   Don't post it as 212 separate messages or replies to the immediate
> >>   previous patch.
> >>
> >> So, in short, if you're adding a whole new arch, just post it as a
> >> single patch or a series of several patches if it requires changes
> >> outside of the specific arch subtree.
> > 
> > Crap. a single patch is a major PITA for review. It's even worse than
> > 211 per file patches.
> 
> Cut the crap.  A single patch may not be perfect for reviewing but
> archs are often merged as a single giant patch as bisection is
> meaningless anyway.

It's not a question of merging. It's a question of reviewing and I've
done quite a bunch of reviews on new archs, so I know what I'm talking
about. Reviewing a single patch with everything and the world included
is just not workable.

Thanks,

	tglx
