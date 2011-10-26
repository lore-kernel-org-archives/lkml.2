Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab1JZIOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 04:14:19 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:51184 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932427Ab1JZIOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 04:14:17 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18WGQAqYr4WXaTYpB8dQ5rxZD/nGoTj3oBQw5pRNx
	SLfRVANuhw+bK8
Subject: Re: Linux 3.0.8
From: Mike Galbraith <efault@gmx.de>
To: Valdis.Kletnieks@vt.edu
Cc: Greg KH <gregkh@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
In-Reply-To: <14295.1319532063@turing-police.cc.vt.edu>
References: <20111025051928.GA7997@kroah.com>
	 <4EA64BDC.8050709@xenotime.net> <20111025070240.GB9415@suse.de>
	 <14295.1319532063@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Oct 2011 10:14:10 +0200
Message-ID: <1319616850.4829.28.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-25 at 04:41 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 25 Oct 2011 09:02:40 +0200, Greg KH said:
> > On Mon, Oct 24, 2011 at 10:40:44PM -0700, Randy Dunlap wrote:
> > > On 10/24/11 22:19, Greg KH wrote:
> > > > All users of the 3.0 kernel series must upgrade.
> > > I noticed that "must" word in 3.0.7 also.  Please explain.
> > Nothing new, I've been saying that for years.
> 
> I think Randy means that out of the 29 commits for .7->.8, there's only one
> (Hugh Dicken's mremap fix) and *maybe* Peter Zijlstra's cputimer fix, which
> even *possibly* rise to the "all users" level, as everything else is against
> XFS or CIFS or ARM or something else that's not an across-the-board issue.
> 
> And the changelog for the mremap commit says that "but this lucky report
> hints", which sort of implies it's a very hard-to-hit bug that nobody even knew
> was there.
> 
> So it's not obvious from just the shortlog that it's a "MUST upgrade"  category.

Seems like perfectly fine boilerplate to me.  If I want the warmest
fuzzy I can get, I must upgrade.  Peter's patch fixed a box killer that
I don't care to hit (dead bugs being kinda boring), so I must upgrade.

	-Mike

