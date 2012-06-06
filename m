Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab2FFOWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:22:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49894 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab2FFOWq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:22:46 -0400
Message-ID: <1338992556.2749.118.camel@twins>
Subject: Re: [PATCH 3/5] perf, x86: Check LBR format capability
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        eranian@google.com
Date: Wed, 06 Jun 2012 16:22:36 +0200
In-Reply-To: <20120606141419.GE28225@tassilo.jf.intel.com>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
	 <1338944211-28275-3-git-send-email-andi@firstfloor.org>
	 <1338979224.2749.93.camel@twins>
	 <20120606141419.GE28225@tassilo.jf.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 07:14 -0700, Andi Kleen wrote:
> On Wed, Jun 06, 2012 at 12:40:24PM +0200, Peter Zijlstra wrote:
> > On Tue, 2012-06-05 at 17:56 -0700, Andi Kleen wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > Double check the CPU has a LBR format we support before using it.
> > > 
> > > Also I made the init functions __init while I was on it. 
> > 
> > Why? Its all after a model test anyway.
> 
> Because the spec says we should check it.

The spec says lots of things.. but being that LBR is very much model
specific I really can't be bothered.

> It could catch bad VMs and other inconsistencies and it's the right thing
> to do.

That might be a reason, but does it?, and why wasn't that in the
changelog?
