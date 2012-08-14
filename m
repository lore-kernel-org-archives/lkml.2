Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab2HNOji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:39:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44130 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752000Ab2HNOjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:39:37 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19jlcEo6TZj3ZfdykMt6kKS5a+eL3wbsD5TeCFLIW
	pHfpFHPigBKN2P
Message-ID: <1344955168.14924.85.camel@marge.simpson.net>
Subject: Re: [rfc patch] fs,reiserfs: unlock superblock before callling
 reiserfs_quota_on_mount()
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 14 Aug 2012 16:39:28 +0200
In-Reply-To: <1344954183.6724.8.camel@gandalf.stny.rr.com>
References: <1344949583.14924.36.camel@marge.simpson.net>
	 <1344954183.6724.8.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-14 at 10:23 -0400, Steven Rostedt wrote: 
> On Tue, 2012-08-14 at 15:06 +0200, Mike Galbraith wrote:
> > Greetings,
> > 
> > Using openSUSE's "partitioner" gizmo to set up a reiserfs partition with
> > quotas and whatnot enabled rewarded me with a deadlock.
> 
> Is this just a -rt bug? Can't this deadlock also in mainline?

It didn't with a NOPREEMPT kernel the one time I tried it, which seemed
mighty odd when I stared at the rt deadlock.  I'll give it another go, I
likely just munged q/d NOPREEMPT test.

-Mike

