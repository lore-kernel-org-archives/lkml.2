Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab0EDXtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 19:49:23 -0400
Received: from tundra.namei.org ([65.99.196.166]:50023 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907Ab0EDXtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 19:49:22 -0400
Date: Wed, 5 May 2010 09:44:56 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       "David S. Miller" <davem@davemloft.net>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH tip/core/rcu 21/48] remove all rcu head initializations,
 except on_stack initializations
In-Reply-To: <1273004398-19760-21-git-send-email-paulmck@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1005050944230.12883@tundra.namei.org>
References: <20100504201934.GA19234@linux.vnet.ibm.com> <1273004398-19760-21-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 May 2010, Paul E. McKenney wrote:

> From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> 
> Remove all rcu head inits. We don't care about the RCU head state before passing
> it to call_rcu() anyway. Only leave the "on_stack" variants so debugobjects can
> keep track of objects on stack.
> 
> This patch applies to current -tip based on 2.6.34-rc2.

Reviewed-by: James Morris <jmorris@namei.org>

-- 
James Morris
<jmorris@namei.org>
