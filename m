Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab0KMXbl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 18:31:41 -0500
Received: from canuck.infradead.org ([134.117.69.58]:50222 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab0KMXbi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 18:31:38 -0500
Subject: Re: [RFC][PATCH 06/22] sched: SCHED_DEADLINE handles spacial
 kthreads
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Raistlin <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1289681497.2109.270.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333876.8661.147.camel@Palantir> <1289486096.2084.123.camel@laptop>
	 <20101111152750.GA2510@redhat.com> <1289490202.2084.140.camel@laptop>
	 <20101111163242.GA5697@redhat.com> <1289673355.2109.79.camel@laptop>
	 <20101113195857.GA11411@redhat.com>  <1289680291.2109.244.camel@laptop>
	 <1289681497.2109.270.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 14 Nov 2010 00:31:21 +0100
Message-ID: <1289691081.2109.452.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-13 at 21:51 +0100, Peter Zijlstra wrote:
> Latest version, I actually compiled it too ! 

Locks up solid though,.. even the NMI watchdog doesn't seem to trigger
anymore (or its broken too)...

/me goes prod at it a bit more
