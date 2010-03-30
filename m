Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab0C3QXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 12:23:01 -0400
Received: from www.tglx.de ([62.245.132.106]:58226 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab0C3QXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 12:23:00 -0400
Date: Tue, 30 Mar 2010 18:21:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, adobriyan@gmail.com,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 1/5] Debugobjects transition check
In-Reply-To: <20100329143701.765545140@efficios.com>
Message-ID: <alpine.LFD.2.00.1003301819060.32352@localhost.localdomain>
References: <20100329143405.252313609@efficios.com> <20100329143701.765545140@efficios.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010, Mathieu Desnoyers wrote:

> Implement a basic state machine checker in the debugobjects.

Can you please add some real explanation how that checker works and
why we want to have it ?

Thanks,

	tglx



