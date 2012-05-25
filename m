Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab2EYKmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 06:42:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:59072 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab2EYKmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 06:42:54 -0400
Subject: Re: [RFC][PATCH 00/15] sched: SCHED_DEADLINE v5
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com
In-Reply-To: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>
References: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 12:42:49 +0200
Message-ID: <1337942569.9783.183.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 23:42 +0200, Juri Lelli wrote:
> Still missing/incomplete:
>   - (c)group based bandwidth management, and maybe scheduling;

The b/w stuff for cgroups shouldn't be particularly hard, right? It
shouldn't be more than ensuring the utilization sum of all children
stays below the set value.

Or am I missing something?

>   - bandwidth inheritance (to replace deadline/priority inheritance);

Yes please, but this is somewhat longer term, I think the band-aids in
place are sufficient to allow us to move fwd.

>   - access control for non-root users (and related security concerns to
>     address). 

Right, so could you detail what all is needed to allow regular users to
create dl tasks?

Aside from this, Ingo, Thomas, Steven do you agree in merging these
patches as a suitable base to continue work from?

