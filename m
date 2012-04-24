Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab2DXQ11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:27:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:47725 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab2DXQ10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:27:26 -0400
Message-ID: <1335284820.28150.203.camel@twins>
Subject: Re: [PATCH 10/16] sched: add resource limits for -deadline tasks.
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Tue, 24 Apr 2012 18:27:00 +0200
In-Reply-To: <4F96C52C.7030606@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	  <1333696481-3433-11-git-send-email-juri.lelli@gmail.com>
	 <1335280075.28150.202.camel@twins> <4F96C52C.7030606@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 17:22 +0200, Juri Lelli wrote:

> Ok, but considering what you said regarding setscheduler security problems:

> Are you suggesting to drop/postpone this to some later time?

Yeah, I think we can put this on the end of the queue and try and get
some of the basic infrastructure merged first.
