Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab0CVP40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 11:56:26 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50159 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990Ab0CVP4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 11:56:24 -0400
Date: Mon, 22 Mar 2010 08:56:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] tree/tiny rcu: Add debug RCU head option (v2)
Message-ID: <20100322155616.GI2517@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100319013024.GA28456@Krystal>
 <4BA2FA01.30102@cn.fujitsu.com>
 <alpine.DEB.2.00.1003190730440.9184@router.home>
 <20100319144434.GA2520@linux.vnet.ibm.com>
 <20100319165637.GA28123@Krystal>
 <20100319171105.GB2520@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1003220935370.15360@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003220935370.15360@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 09:37:55AM -0500, Christoph Lameter wrote:
> SLAB overloads "struct slab" with the rcu_head. Its not that critical
> there since the metadata allocated for each slab page is larger. SLUB does
> not have such a per slab page metadata structure and limits its metadata
> to what is available in the page struct.

Thank you for the info!

FWIW, Mathieu is now using debug objects, which permits him to keep
rcu_head the same size.

							Thanx, Paul
