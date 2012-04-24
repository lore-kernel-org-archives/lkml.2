Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2DXJAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 05:00:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33532 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129Ab2DXJAe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 05:00:34 -0400
Message-ID: <1335258004.28150.183.camel@twins>
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>, tglx@linutronix.de,
        mingo@redhat.com, rostedt@goodmis.org, cfriesen@nortel.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
Date: Tue, 24 Apr 2012 11:00:04 +0200
In-Reply-To: <4F965471.2030905@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	   <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>
	  <1335191701.28150.155.camel@twins> <4F9577CF.2020400@gmail.com>
	 <1335195826.28150.177.camel@twins> <4F958627.8070109@gmail.com>
	 <4F95D41F.5060700@sssup.it> <4F965471.2030905@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 09:21 +0200, Juri Lelli wrote:
> Well, depends on how much effort will this turn to require. I personally
> would prefer to be able to come out with a new release ASAP. Just to
> continue the discussion with the most of the comments addressed and a
> more updated code (I also have a mainline version of the patchset
> quite ready). 

Right, one thing we can initially do is require root for using
SCHED_DEADLINE and then when later work closes all the holes and we've
added user bandwidth controls we can allow everybody in.


