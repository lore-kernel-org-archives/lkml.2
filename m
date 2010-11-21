Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab0KUS2N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 13:28:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52269 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab0KUS2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 13:28:12 -0500
Date: Sun, 21 Nov 2010 19:28:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>, Andi Kleen <andi@firstfloor.org>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC PATCH 3/3 v2] perf: Update perf tool to monitor uncore
 events
Message-ID: <20101121182810.GA16299@basil.fritz.box>
References: <1290340907.2245.125.camel@localhost>
 <340872239c47b2ec237c88488cb7b6ac.squirrel@www.firstfloor.org>
 <AANLkTi=bxEgsLjk-1CK4pSmknyxR_y3OxTJ9DZ_dBW8n@mail.gmail.com>
 <1290361529.2153.42.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290361529.2153.42.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would argue against restricting the tool, print a warning perhaps. I
> mean, give the user all the rope he needs and tell him how to tie the
> knot is the unix way, right? :-)

WARNING: the following information is completely useless and wrong

Basically reporting rip here is lying and don't think lying is the
"Unix way".

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
