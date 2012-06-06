Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab2FFOOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:14:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47785 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab2FFOOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:14:35 -0400
Message-ID: <1338992061.2749.111.camel@twins>
Subject: Re: [PATCH 1/5] perf, x86: Don't assume the alternative cycles
 encoding is architectural
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        eranian@google.com
Date: Wed, 06 Jun 2012 16:14:21 +0200
In-Reply-To: <20120606141247.GD28225@tassilo.jf.intel.com>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
	 <1338979188.2749.92.camel@twins>
	 <20120606141247.GD28225@tassilo.jf.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 07:12 -0700, Andi Kleen wrote:
> On Wed, Jun 06, 2012 at 12:39:48PM +0200, Peter Zijlstra wrote:
> > On Tue, 2012-06-05 at 17:56 -0700, Andi Kleen wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > cycles:p uses an special cycles encoding by default. However that is not
> > > architectural, so it can only be used when the CPU is known
> > > (it already caused problems on Sandy Bridge). It may or may not work
> > > on future CPUs.
> > > 
> > > So make it opt-in only. Right now I enabled it on Core2, Nehalem, Westmere
> > > and not on Sandy-Bridge or Atom.
> > 
> > No. 
> 
> What do you mean? Are you claiming it's architectural?

I mean this patch is shite.

You don't disable it because it doesn't work some place, you fix it.

But don't bother, its already done.
