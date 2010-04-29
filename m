Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921Ab0D3RzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:55:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60148 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758906Ab0D3Ryw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:54:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 6/8] PM: Add suspend blocking work.
Date: Thu, 29 Apr 2010 23:08:22 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>
References: <1272429119-12103-1-git-send-email-arve@android.com> <201004282308.10751.rjw@sisk.pl> <20100429185851.GA13862@redhat.com>
In-Reply-To: <20100429185851.GA13862@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004292308.22457.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 April 2010, Oleg Nesterov wrote:
> On 04/28, Rafael J. Wysocki wrote:
> >
> > On Wednesday 28 April 2010, Tejun Heo wrote:
> > > On 04/28/2010 09:40 PM, Oleg Nesterov wrote:
> > > >> +int schedule_suspend_blocking_work(struct suspend_blocking_work *work)
> > > >> +{
> > > >> ...
> > > >> +	ret = schedule_work(&work->work);
> > > >
> > > > Off-topic. We should probably export keventd_wq to avoid the duplications
> > > > like this.
> > >
> > > Yeah, had about the same thought.  cmwq exports it so I didn't suggest
> > > it at this point but then again we don't really know whether or when
> > > that series is going in
> >
> > As soon as there are no major objections.  At least to my tree.
> >
> > > so it might be a good idea to make that change now.  Hmm...
> >
> > I'd rather like a follow-up patch changing that, if poss.
> 
> Confused. Rafael, do you mean you dislike this change now?

No, I'm fine with the change itself, but I wouldn't like to make the suspend
blockers patchset depend on something in a different tree.  If it's not the
case, I have no objections.

Rafael
