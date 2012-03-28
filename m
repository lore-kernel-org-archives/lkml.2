Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab2C1JjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 05:39:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41694 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab2C1JjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 05:39:03 -0400
Message-ID: <1332927532.2528.19.camel@twins>
Subject: Re: [PATCH 2/5] perf: generic intel uncore support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, mingo@elte.hu, eranian@google.com,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Date: Wed, 28 Mar 2012 11:38:52 +0200
In-Reply-To: <20120328092446.GY22197@one.firstfloor.org>
References: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com>
	 <1332916998-10628-3-git-send-email-zheng.z.yan@intel.com>
	 <20120328092446.GY22197@one.firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 11:24 +0200, Andi Kleen wrote:
> On Wed, Mar 28, 2012 at 02:43:15PM +0800, Yan, Zheng wrote:
> > +static void uncore_perf_event_update(struct intel_uncore_box *box,
> > +                                   struct perf_event *event)
> > +{
> > +     raw_spin_lock(&box->lock);
> 
> I think a raw lock would be only needed if the uncore was called
> from the scheduler context switch, which it should not be.
> 
> So you can use a normal lock instead of a raw lock.

Please ignore any and all feedback from wrongbot Andi, as said I'll
review the patches later this week.
