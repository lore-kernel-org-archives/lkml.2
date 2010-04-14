Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab0DOH3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:29:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:49112 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353Ab0DOH3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:29:34 -0400
Subject: Re: [RFC][PATCH 0/11] sched: SCHED_DEADLINE v2
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>, Henrik Austad <henrik@austad.us>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Claudio Scordino <claudio@evidence.eu.com>,
       michael trimarchi <trimarchi@retis.sssup.it>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>,
       Nicola Manica <nicola.manica@gmail.com>,
       Luca Abeni <luca.abeni@unitn.it>
In-Reply-To: <1267383976.13676.79.camel@Palantir>
References: <1267383976.13676.79.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 12:17:39 +0200
Message-ID: <1271240259.32749.17.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Overall very nice code, awesome!

On Sun, 2010-02-28 at 20:06 +0100, Raistlin wrote:
>  - migration of tasks throughout push and pull (as in -rt), to make it
>    possible to deploy global-EDF scheduling. Patches are ready, they're
>    just being tested and adapted to this last version;

Please post a version that includes this :-)

>  - refinements in deadline inheritance, especially regarding the
>    possibility of retaining bandwidth isolation among non-interacting
>    tasks. This is being studied from both theoretical and practical
>    points of view, and hopefully we can have some demonstrative code
>    soon. 

Right, I hope that with changing the PI code to use RB trees this will
become much less of a kludge than fudging the ->prio field.

