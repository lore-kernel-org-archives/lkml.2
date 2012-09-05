Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077Ab2IERe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 13:34:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41498 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab2IEReY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 13:34:24 -0400
Date: Wed, 5 Sep 2012 19:34:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rakib.mullick@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Fix load avg vs cpu-hotplug
Message-ID: <20120905173416.GA6400@gmail.com>
References: <1345454817.23018.27.camel@twins>
 <tip-f319da0c6894fcf55e21320e40506418a2aad629@git.kernel.org>
 <1346848616.2600.26.camel@twins>
 <20120905132939.GA3480@gmail.com>
 <1346864493.2600.27.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346864493.2600.27.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2012-09-05 at 15:29 +0200, Ingo Molnar wrote:
> > > Oh argh.. this patch isn't actually right.. I actually removed 
> > > it from my series but forgot to update the tarball.
> > 
> > Sigh.
> 
> Yeah, sorry about that, jet-lag makes me do stupid at a higher 
> rate than usual :/

No problem! :-)

> > > Ingo can you still make it go away or should I do a delta?
> > 
> > Please do a delta.
> 
> Ok, will do.

Thanks!

	Ingo
