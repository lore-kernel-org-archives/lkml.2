Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab2GBUWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:22:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:42397 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730Ab2GBUW1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:22:27 -0400
Message-ID: <1341260540.23484.25.camel@twins>
Subject: Re: [PATCH 2/5] perf, x86: Enable PDIR precise instruction
 profiling on IvyBridge
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Date: Mon, 02 Jul 2012 22:22:20 +0200
In-Reply-To: <20120702195744.GG11413@one.firstfloor.org>
References: <1341254598-1379-1-git-send-email-andi@firstfloor.org>
	 <1341254598-1379-3-git-send-email-andi@firstfloor.org>
	 <1341256733.23484.11.camel@twins>
	 <20120702195744.GG11413@one.firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 21:57 +0200, Andi Kleen wrote:
> > Already told you no.
> 
> No on what? You don't want PDIR mode? Or you don't like something
> with my implementation?

Both are crap.

If anything its an PEBS alias, we have infrastructure for that, yet you
invent new things.

You do random things like only :pp for no apparent reason.

PDIR is only supported on a single counter, regular PEBS 'instructions'
events allow for 4+ counters. Therefore a direct substitution is not
valid.


