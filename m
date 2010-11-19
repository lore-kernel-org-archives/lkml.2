Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab0KSUQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:16:44 -0500
Received: from 1wt.eu ([62.212.114.60]:47490 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756633Ab0KSUQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:16:43 -0500
Date: Fri, 19 Nov 2010 21:16:14 +0100
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: david@lang.hm, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org,
        tj@kernel.org, akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
Message-ID: <20101119201614.GB19329@1wt.eu>
References: <20101116104600.GA24015@suse.de> <20101119191906.GA31760@xanatos> <AANLkTi=OsWEdrfCOHKz+SAtqo7DmK0nNxku7Ev21f0Lh@mail.gmail.com> <alpine.DEB.2.00.1011191156470.19579@asgard.lang.hm> <AANLkTikP5MpT6-WBBfNsP2nK1Cdh=St+nWky_bU9FhSO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikP5MpT6-WBBfNsP2nK1Cdh=St+nWky_bU9FhSO@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 12:04:47PM -0800, Linus Torvalds wrote:
> On Fri, Nov 19, 2010 at 11:58 AM,  <david@lang.hm> wrote:
> >
> > how far back do we need to maintain compatibility with userspace?
> >
> > Is this something that we can revisit in a few years and lock it down then?
> 
> The rule is basically "we never break user space".
> 
> But the "out" to that rule is that "if nobody notices, it's not
> broken". In a few years? Who knows?
> 
> So breaking user space is a bit like trees falling in the forest. If
> there's nobody around to see it, did it really break?

FWIW, I appreciate a lot that non-breaking rule. I have some testing
machines which boot from PXE or USB on a file-system with some old
tools and libc, that are both 2.4 and 2.6 compatible. Everything works
like a charm, the only point of care was to have both module-init-tools
and modutils (obviously) but even that integrates smoothly.

I know quite a lot of people who never replace user-space but only
kernels on their systems, so this non-breaking rule is much welcome !

Willy

