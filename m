Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab2AYHRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 02:17:32 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:55964 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab2AYHRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 02:17:31 -0500
Date: Wed, 25 Jan 2012 08:17:16 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: memcg: fix over reclaiming mem cgroup
Message-ID: <20120125071715.GA7694@cmpxchg.org>
References: <CAJd=RBAbFd=MFZZyCKN-Si-Zt=C6dKVUaG-C7s5VKoTWfY00nA@mail.gmail.com>
 <20120123130221.GA15113@tiehlicka.suse.cz>
 <CALWz4izWYb=_svn=UJ1C--pWXv59H2ahn6EJEnTpJv-dT6WGsw@mail.gmail.com>
 <CAJd=RBAuDABE7u1wyc+45ZGoVos5PnxMe6P=ET-CHf-LChTpgw@mail.gmail.com>
 <20120124082352.GA26289@tiehlicka.suse.cz>
 <CAJd=RBDj5mtWJG0Byi=97Kuu6LnkwdndDO-AUpeYSCTBEy0P5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBDj5mtWJG0Byi=97Kuu6LnkwdndDO-AUpeYSCTBEy0P5A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 09:55:01AM +0800, Hillf Danton wrote:
> On Tue, Jan 24, 2012 at 4:23 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > Barriered?
> >
> pushed out for 3.3-rc2 last night?

New features are only merged during the merge window (between 3.2 and
3.3-rc1), from then on it's only bugfixes to stabilize for release.

My soft limit patch missed this merge window, so the earliest target
is 3.4.  And that's fine, there are still things that need to be
evaluated, like kswapd now reclaiming with priority 0 and
nr_to_reclaim at ULONG_MAX, which Michal pointed out.  Or KAME's
concerns regarding direct soft reclaim and numa setups.
