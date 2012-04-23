Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab2DWJIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:08:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43310 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab2DWJIq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:08:46 -0400
Message-ID: <1335172098.28150.99.camel@twins>
Subject: Re: [PATCH 03/16] sched: SCHED_DEADLINE data structures.
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
Date: Mon, 23 Apr 2012 11:08:18 +0200
In-Reply-To: <1333696481-3433-4-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-4-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
> +struct sched_dl_entity {
> +       struct rb_node  rb_node;
> +       int nr_cpus_allowed; 

I think it would be all-round best to move
sched_rt_entity::nr_cpus_allowed out next to cpus_allowed.
