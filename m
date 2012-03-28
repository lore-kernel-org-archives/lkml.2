Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab2C1K62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 06:58:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55676 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab2C1K60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 06:58:26 -0400
Message-ID: <1332932290.2528.22.camel@twins>
Subject: Re: [RFC PATCH 0/5] perf: Intel uncore pmu counting support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        mingo@elte.hu, eranian@google.com, linux-kernel@vger.kernel.org,
        ming.m.lin@intel.com
Date: Wed, 28 Mar 2012 12:58:10 +0200
In-Reply-To: <20120328085732.GV22197@one.firstfloor.org>
References: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com>
	 <20120328064928.GA21725@gmail.com>
	 <20120328085732.GV22197@one.firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 10:57 +0200, Andi Kleen wrote:
> The main problem is that we don't know currently what events are
> really useful. People need to play around with the raw events
> first to find that out. But to do that really already need some
> in tree support because out of tree is too painful to use: it's 
> a chicken and egg problem. 

So you're saying Intel just made the hardware without any idea if it was
useful or not?

Somehow that seems rather unlikely. It seems to me they had at least one
but very likely several strong use-cases before they designed the
hardware.

What Ingo is asking is to implement these, so that everybody can enjoy
them instead of being a conduit for Intel proprietary tools.

A minimal driver with no users except $$ tools is not acceptable.
