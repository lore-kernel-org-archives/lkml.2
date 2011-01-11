Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab1AKAyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 19:54:06 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53353 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab1AKAyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 19:54:03 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 11 Jan 2011 09:47:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] slub: Fix sysfs circular locking dependency
Message-Id: <20110111094720.e0a16a60.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1101101011250.12243@router.home>
References: <1294172717-6044-1-git-send-email-penberg@kernel.org>
	<alpine.DEB.2.00.1101041939030.27551@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1101050943120.13032@router.home>
	<alpine.DEB.2.00.1101051108520.14761@router.home>
	<AANLkTinft80dXqE-U=YDB23d9=BgXLCxJzgiA_gF4cVL@mail.gmail.com>
	<AANLkTinCZzJWYGnxXq_Nwv7QSkEV4Tg-te-1y0PCeRRY@mail.gmail.com>
	<AANLkTinQMahgVrWLxR0J6Zbh-_SPjxVJ-wuZt8B5TNjc@mail.gmail.com>
	<alpine.DEB.2.00.1101060019140.25879@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1101061107500.8655@router.home>
	<20110107091106.aaa07abe.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1101070922100.3014@router.home>
	<alpine.DEB.2.00.1101071227160.31653@chino.kir.corp.google.com>
	<AANLkTikf-qO-NkysOsgRvH08ju-NkvrqwdfJ=pFjP6WA@mail.gmail.com>
	<alpine.DEB.2.00.1101101011250.12243@router.home>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011 10:12:09 -0600 (CST)
Christoph Lameter <cl@linux.com> wrote:

> On Sat, 8 Jan 2011, Pekka Enberg wrote:
> 
> > On Fri, Jan 7, 2011 at 10:34 PM, David Rientjes <rientjes@google.com> wrote:
> > >  [ Should probably be seperated out into two patches, one for the
> > >   memory hotplug locking addition and one for the slub fix, both
> > >   should be pushed during this merge window.  If so, a comment
> > >   describing the new semantics of lock_memory_hotplug() to protect
> > >   data structures that may be modified in hotplug notifier
> > >   callbacks would be appreciated. ]
> >
> > Agreed.
> 
> Kame-san: Could you do the hotplug piece and the description of the use
> of the memory hotplug locks to protect extensions of data structures for
> new nodes?

will do.

Thanks,
-Kame

