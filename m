Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1HQXDC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 19:03:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab1HQXDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 19:03:00 -0400
Date: Wed, 17 Aug 2011 19:02:19 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.0-git15 Atomic scheduling in pidmap_init
Message-ID: <20110817230219.GJ2227@zod.bos.redhat.com>
References: <20110808020914.GC2385@linux.vnet.ibm.com>
 <20110808025505.GF29058@somewhere>
 <20110808031014.GE2385@linux.vnet.ibm.com>
 <20110809113514.GA27301@somewhere.redhat.com>
 <20110810124528.GC2566@zod.bos.redhat.com>
 <20110814230453.GP2650@linux.vnet.ibm.com>
 <20110815140416.GB2227@zod.bos.redhat.com>
 <20110815152052.GA2389@linux.vnet.ibm.com>
 <20110817223735.GI2227@zod.bos.redhat.com>
 <20110817224916.GO2419@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817224916.GO2419@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 03:49:16PM -0700, Paul E. McKenney wrote:
> On Wed, Aug 17, 2011 at 06:37:35PM -0400, Josh Boyer wrote:
> > On Mon, Aug 15, 2011 at 08:20:52AM -0700, Paul E. McKenney wrote:
> > > On Mon, Aug 15, 2011 at 10:04:17AM -0400, Josh Boyer wrote:
> > > > > Please see the attached.
> > > > 
> > > > Fixed it up quickly to apply on top of -rc2 and it seems to solve the
> > > > problem nicely.  Thanks for the patch.
> > > 
> > > Good to hear!  I guess I should keep it, then.  ;-)
> > 
> > Hey Paul, were you going to send this to Linus for -rc3?  I haven't seen
> > it come across LKML yet.
> 
> I might...  But does it qualify as a regression?  That part of the
> code hasn't changed for some time now.

It's a fix for a problem that is newly surfaced in 3.1.  A regression,
likely not since it's been there forever, but new debugging options
uncovered it.  I'm pretty sure the -rc stage takes fixes even if they
aren't regressions.

josh
