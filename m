Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab0CVOjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:39:52 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:34886 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab0CVOjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:39:51 -0400
Date: Mon, 22 Mar 2010 09:37:55 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] tree/tiny rcu: Add debug RCU head option (v2)
In-Reply-To: <20100319171105.GB2520@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1003220935370.15360@router.home>
References: <20100319013024.GA28456@Krystal> <4BA2FA01.30102@cn.fujitsu.com> <alpine.DEB.2.00.1003190730440.9184@router.home> <20100319144434.GA2520@linux.vnet.ibm.com> <20100319165637.GA28123@Krystal> <20100319171105.GB2520@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLAB overloads "struct slab" with the rcu_head. Its not that critical
there since the metadata allocated for each slab page is larger. SLUB does
not have such a per slab page metadata structure and limits its metadata
to what is available in the page struct.



