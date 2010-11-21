Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0KUSa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 13:30:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:44432 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab0KUSaZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 13:30:25 -0500
Subject: Re: [RFC PATCH 3/3 v2] perf: Update perf tool to monitor uncore
 events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stephane Eranian <eranian@google.com>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20101121182810.GA16299@basil.fritz.box>
References: <1290340907.2245.125.camel@localhost>
	 <340872239c47b2ec237c88488cb7b6ac.squirrel@www.firstfloor.org>
	 <AANLkTi=bxEgsLjk-1CK4pSmknyxR_y3OxTJ9DZ_dBW8n@mail.gmail.com>
	 <1290361529.2153.42.camel@laptop>  <20101121182810.GA16299@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 21 Nov 2010 19:30:38 +0100
Message-ID: <1290364238.2153.89.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-21 at 19:28 +0100, Andi Kleen wrote:
> > I would argue against restricting the tool, print a warning perhaps. I
> > mean, give the user all the rope he needs and tell him how to tie the
> > knot is the unix way, right? :-)
> 
> WARNING: the following information is completely useless and wrong
> 
> Basically reporting rip here is lying and don't think lying is the
> "Unix way".

Yeah, unless there's only one task running on that socket.. Dude,
really, lighten up.
