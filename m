Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab2CET6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 14:58:40 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:43031 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757583Ab2CET6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 14:58:38 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+zriojBsSz4il+Dp41z3N/EW9VkwHkzcH2shFQzN
	fL/b3d6cYU1WlJ
Message-ID: <1330977508.7391.7.camel@marge.simpson.net>
Subject: Re: [RFD] cgroup: about multiple hierarchies
From: Mike Galbraith <efault@gmx.de>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Michal Schmidt <mschmidt@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Date: Mon, 05 Mar 2012 20:58:28 +0100
In-Reply-To: <1330962421.7368.69.camel@marge.simpson.net>
References: <20120221211938.GE12236@google.com>
	 <20120222163858.GB4128@redhat.com> <20120222165714.GC4128@redhat.com>
	 <1329990094.24994.64.camel@twins> <1330006399.11248.20.camel@twins>
	 <4F4FAF89.3090706@redhat.com> <1330633603.7414.49.camel@marge.simpson.net>
	 <20120301210213.GF13533@redhat.com>
	 <1330639448.7414.97.camel@marge.simpson.net>
	 <20120305124310.GD10929@tango.0pointer.de>
	 <1330962421.7368.69.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 16:47 +0100, Mike Galbraith wrote: 
> On Mon, 2012-03-05 at 13:43 +0100, Lennart Poettering wrote: 

> > Just set DefaultControllers= in /etc/systemd/system.conf to an empty
> > string and systemd will not make use of any hierarchy beyond its private
> > name=systemd named hierarchy.
> 
> I updated my laptop to openSUSE 12.1 over the weekend, so tried it.  It
> didn't work

Bah, yes it did, subdir is gone.  I shouldn't multitask.

-Mike


