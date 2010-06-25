Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab0FYX3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 19:29:33 -0400
Received: from kroah.org ([198.145.64.141]:33353 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756434Ab0FYX30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 19:29:26 -0400
Date: Fri, 25 Jun 2010 15:54:10 -0700
From: Greg KH <greg@kroah.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg KH <gregkh@suse.de>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, stable <stable@kernel.org>
Subject: Re: [stable] [PATCH for stable] tracing: Consolidate protection of
 reader access to the ring buffer
Message-ID: <20100625225410.GJ10683@kroah.com>
References: <1277212983.9181.27.camel@gandalf.stny.rr.com>
 <20100622132839.GA18974@suse.de>
 <1277213804.9181.30.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277213804.9181.30.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 09:36:44AM -0400, Steven Rostedt wrote:
> On Tue, 2010-06-22 at 06:28 -0700, Greg KH wrote:
> > On Tue, Jun 22, 2010 at 09:23:03AM -0400, Steven Rostedt wrote:
> > > Greg,
> > > 
> > > Johannes has been hitting a bug in 2.6.33 that we believe is fixed with
> > > the following patch. The bug is hit a few times a week, so it is hard to
> > > verify. But we are only hitting it with .33 and not .34, and this patch
> > > looks like it would be the one to fix it.
> > > 
> > > Can you apply this patch to the 2.6.33 stable series.
> > 
> > If you are ok with it, I'll apply it as it does look a little "big" for
> > a stable kernel :)
> 
> Yeah, I usually would not ask for a patch this size to go into stable,
> but it has been in mainline for a while, and seems to be the fix for a
> bug we are hitting in .33.

Ok, all queued up now.

greg k-h
