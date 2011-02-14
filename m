Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab1BNWaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:30:07 -0500
Received: from blu0-omc1-s16.blu0.hotmail.com ([65.55.116.27]:60182 "EHLO
	blu0-omc1-s16.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948Ab1BNWaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:30:04 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP23851725CDB84163CDDE2296D00@phx.gbl>
Date: Mon, 14 Feb 2011 17:29:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Steven Rostedt <rostedt@goodmis.org>, David Miller <davem@davemloft.net>,
        peterz@infradead.org, will.newton@gmail.com, jbaron@redhat.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <1297707868.5226.189.camel@laptop> <1297718964.23343.75.camel@gandalf.stny.rr.com> <1297719576.23343.80.camel@gandalf.stny.rr.com> <20110214.134600.179933733.davem@davemloft.net> <1297722030.23343.86.camel@gandalf.stny.rr.com> <4D59AAFC.7010503@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4D59AAFC.7010503@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:28:38 up 313 days,  8:18,  8 users,  load average: 2.00, 1.79,
	1.58
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 14 Feb 2011 22:30:03.0574 (UTC) FILETIME=[B9463D60:01CBCC96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> On 02/14/2011 02:20 PM, Steven Rostedt wrote:
> > 
> > Ideally, we would like a single atomic_read() but due to these wacky
> > archs, it may not be possible.
> > 
> 
> #ifdef ARCH_ATOMIC_READ_SUCKS_EGGS?
> 
> 	-hpa

lol :)

Hrm, I wonder if it might cause problems with combinations of "cmpxchg"
and "read" performed on a variable (without using atomic.h).

Mathieu

> 
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
