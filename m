Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850Ab0EESgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 14:36:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50872 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757556Ab0EESgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 14:36:11 -0400
Date: Wed, 5 May 2010 14:36:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Garrett <mjg@redhat.com>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, <magnus.damm@gmail.com>,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
In-Reply-To: <20100505173337.GA1671@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.1005051432120.1885-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 May 2010, Matthew Garrett wrote:

> On Wed, May 05, 2010 at 02:56:22PM +0100, Mark Brown wrote:
> 
> > If the conclusion is that we don't have anything generic within the
> > kernel then it'd be good to at least have this explicitly spelled out so
> > that we're clear what everyone thinks is going on here and how things
> > are supposed to work.  At the minute it doesn't feel like we've had the
> > discussion so we could end up working at cross purposes.  I don't want
> > to end up in the situation where I have to work around the APIs I'm
> > using without the relevant maintainers having sight of that since that
> > not only am I likely to be missing some existing solution to the problem
> > but is also prone to causing problems maintaining the underlying API.
> 
> We seem to have ended up managing most of our PM infrastructure 
> iteratively. If the concern is more about best practices than intrinsic 
> incompatibilities, I'd lean towards us being better off merging this now 
> and then working things out over the next few releases as we get a 
> better understanding of the implications. The main thing that we have to 
> get right in the short term is the userspace API - everything else is 
> easier to fix up as we go along.

This particular question could use a little more discussion.  I'm
interested to know, for example, under what conditions you would or
would not want to shut down an autonomous codec while going into system 
suspend on a cell phone.

Clearly if there's a call in progress you don't want to shut the codec
down.  Are there any other circumstances?  Would they vary according to
whether the suspend was forced or opportunistic?

In short, I'm trying to get at how much information drivers _really_ 
need to have about the reason for a system suspend.

Alan Stern

