Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab2CAU05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:26:57 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:56883 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751743Ab2CAU0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:26:55 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18RH9FC2zERk6jd2Sp63aWfTJJSdzaEpoKOAqLI8Z
	dhxvQTzTRgKcrC
Message-ID: <1330633603.7414.49.camel@marge.simpson.net>
Subject: Re: [RFD] cgroup: about multiple hierarchies
From: Mike Galbraith <efault@gmx.de>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Date: Thu, 01 Mar 2012 21:26:43 +0100
In-Reply-To: <4F4FAF89.3090706@redhat.com>
References: <20120221211938.GE12236@google.com>
	 <20120222163858.GB4128@redhat.com> <20120222165714.GC4128@redhat.com>
	 <1329990094.24994.64.camel@twins> <1330006399.11248.20.camel@twins>
	 <4F4FAF89.3090706@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-01 at 18:19 +0100, Michal Schmidt wrote: 
> Dne 23.2.2012 15:13, Peter Zijlstra napsal:
> > My utter disregard for cgroups comes from having to actually implement a
> > controller for them, its a frigging nightmare. The systemd retards
> > mandating all this nonsense for booting a machine is completely bonghit
> > inspired and hasn't made me feel any better about it.
> 
> systemd requires only CONFIG_CGROUPS=y. It does not need any controllers.
> 
> The insults are entirely unnecessary.

At the risk of insulting any systemd person, I recently upgraded my box,
and had my very first encounter with systemd.  It didn't go well at all,
to say the very least.  In fact, it quickly became a violent removal.

After the fact, when I queried, I was told straight out that I should
live in harmony with the cgroups configuration systemd set up for me and
be happy.  For the nonce, you can remove it, and here's how (thanks for
that guys), but that removal option is _going_ to go away.  No, you
can't simply turn our cgroup setup off and control your box as if you
actually _own_ the thing, because cgroups is an integral part of the
systemd concept.

Really.  I hope that was idiotic fanboy tripe, because that flat ain't
gonna happen here, ever.

Q: you say systemd requires CONFIG_CGROUPS=y.  Why is that?  It's taking
over sysvinits job afaiui, what does that have to do with cgroups?

-Mike

