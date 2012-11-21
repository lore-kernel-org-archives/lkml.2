Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab2KUJav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:30:51 -0500
Received: from shutemov.name ([204.155.152.216]:37560 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab2KUJas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:30:48 -0500
Date: Wed, 21 Nov 2012 11:30:56 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: David Rientjes <rientjes@google.com>
Cc: Glauber Costa <glommer@parallels.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
Message-ID: <20121121093056.GA31882@shutemov.name>
References: <20121115073420.GA19036@lizard.sbx05977.paloaca.wayport.net>
 <alpine.DEB.2.00.1211142351420.4410@chino.kir.corp.google.com>
 <20121115085224.GA4635@lizard>
 <alpine.DEB.2.00.1211151303510.27188@chino.kir.corp.google.com>
 <50A60873.3000607@parallels.com>
 <alpine.DEB.2.00.1211161157390.2788@chino.kir.corp.google.com>
 <50A6AC48.6080102@parallels.com>
 <alpine.DEB.2.00.1211161349420.17853@chino.kir.corp.google.com>
 <50AA3ABF.4090803@parallels.com>
 <alpine.DEB.2.00.1211200950120.4200@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211200950120.4200@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 10:02:45AM -0800, David Rientjes wrote:
> On Mon, 19 Nov 2012, Glauber Costa wrote:
> 
> > >> In the case I outlined below, for backwards compatibility. What I
> > >> actually mean is that memcg *currently* allows arbitrary notifications.
> > >> One way to merge those, while moving to a saner 3-point notification, is
> > >> to still allow the old writes and fit them in the closest bucket.
> > >>
> > > 
> > > Yeah, but I'm wondering why three is the right answer.
> > > 
> > 
> > This is unrelated to what I am talking about.
> > I am talking about pre-defined values with a specific event meaning (in
> > his patchset, 3) vs arbitrary numbers valued in bytes.
> > 
> 
> Right, and I don't see how you can map the memcg thresholds onto Anton's 
> scheme

BTW, there's interface for OOM notification in memcg. See oom_control.
I guess other pressure levels can also fit to the interface.

-- 
 Kirill A. Shutemov
