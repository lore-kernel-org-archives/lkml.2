Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965440Ab1GOKOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 06:14:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55565 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965014Ab1GOKOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 06:14:33 -0400
Subject: Re: [PATCH] sched: Separate group-scheduling code more clearly
From: Peter Zijlstra <peterz@infradead.org>
To: "Jan H." =?ISO-8859-1?Q?Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1310661163-16606-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1310580816-10861-1-git-send-email-schnhrr@cs.tu-berlin.de>
	 <1310580816-10861-4-git-send-email-schnhrr@cs.tu-berlin.de>
	 <1310590063.2586.32.camel@twins>
	 <1310661163-16606-1-git-send-email-schnhrr@cs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Jul 2011 12:14:16 +0200
Message-ID: <1310724856.2586.298.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-14 at 18:32 +0200, Jan H. Schönherr wrote:
> 
> I get your point, then what about doing it the other way round?
> The patch below should be more to your liking.

Yes, Thanks!

> One could do something similar with sched_init() to get rid of
> some #ifdefs, i. e. separating code based on features instead
> of handling all features intermixed. Not sure whether it is 
> worth the effort, though...

I'll try and remember next time someone needs to touch that code ;-)

> PS: This time with an extra From line, so that your tools hopefully
> work without any problems. :) 

They do, again thanks!
