Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319Ab0JMPtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 11:49:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab0JMPtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 11:49:07 -0400
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, systemtap@sources.redhat.com,
        ltt-dev@lists.casi.polymtl.ca, Steven Rostedt <rostedt@goodmis.org>,
        mingo@elte.hu, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Elena Zannoni <elena.zannoni@oracle.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Aaron Spear <aaron_spear@mentor.com>,
        Tasneem Brutch - SISA <t.brutch@sisa.samsung.com>,
        Tim Bird <tim.bird@am.sony.com>, dominique.toupin@ericsson.com,
        Andi Kleen <andi@firstfloor.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Philippe Maisonneuve <Philippe.Maisonneuve@windriver.com>,
        Felix Burton <Felix.Burton@windriver.com>,
        Andrew McDermott <Andrew.McDermott@windriver.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: [RFC] Common Trace Format Proposal for Linux (v1)
References: <20101005193712.GB25605@Krystal>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Wed, 13 Oct 2010 11:48:09 -0400
In-Reply-To: <20101005193712.GB25605@Krystal> (Mathieu Desnoyers's message of "Tue, 5 Oct 2010 15:37:12 -0400")
Message-ID: <y0miq166qme.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi -

mathieu wrote:

> [...]
> Metadata attribute representation:
>   align = value;                                /* value in bits */
> [...]
>   byte_order = native OR network OR be OR le;	/* network and be are aliases */
> [...]

Is there some reason to invent a new textual syntax for describing
how to pack structs?  There is DWARF, ASN.1, C, ....

- FChE
