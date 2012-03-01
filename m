Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab2CAWEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 17:04:20 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:46949 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755592Ab2CAWER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 17:04:17 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/rRNZVCknrSD/Ig1lVL1NmcHt6byln6tETJDA/aF
	d7vnCiGzc3bc6S
Message-ID: <1330639448.7414.97.camel@marge.simpson.net>
Subject: Re: [RFD] cgroup: about multiple hierarchies
From: Mike Galbraith <efault@gmx.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Michal Schmidt <mschmidt@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Date: Thu, 01 Mar 2012 23:04:08 +0100
In-Reply-To: <20120301210213.GF13533@redhat.com>
References: <20120221211938.GE12236@google.com>
	 <20120222163858.GB4128@redhat.com> <20120222165714.GC4128@redhat.com>
	 <1329990094.24994.64.camel@twins> <1330006399.11248.20.camel@twins>
	 <4F4FAF89.3090706@redhat.com> <1330633603.7414.49.camel@marge.simpson.net>
	 <20120301210213.GF13533@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-01 at 16:02 -0500, Vivek Goyal wrote: 
> On Thu, Mar 01, 2012 at 09:26:43PM +0100, Mike Galbraith wrote:

> > Q: you say systemd requires CONFIG_CGROUPS=y.  Why is that?  It's taking
> > over sysvinits job afaiui, what does that have to do with cgroups?
> 
> I think they were using it to track all the children forked by a service
> and cleanup all of them if need be. So they just need it for logical
> grouping functionality and don't require any controllers as such.

Hm.  Controllers are perhaps not required, but cpu controller was
configured and used without consent.  I didn't receive an offer.

-Mike

