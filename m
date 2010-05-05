Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760384Ab0EEAD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 20:03:28 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54250 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760306Ab0EEAD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 20:03:26 -0400
Date: Tue, 4 May 2010 17:03:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
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
Subject: Re: [PATCH tip/core/rcu 21/48] remove all rcu head
 initializations, except on_stack initializations
Message-ID: <20100505000319.GI2639@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100504201934.GA19234@linux.vnet.ibm.com>
 <1273004398-19760-21-git-send-email-paulmck@linux.vnet.ibm.com>
 <alpine.LRH.2.00.1005050944230.12883@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1005050944230.12883@tundra.namei.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 09:44:56AM +1000, James Morris wrote:
> On Tue, 4 May 2010, Paul E. McKenney wrote:
> 
> > From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > 
> > Remove all rcu head inits. We don't care about the RCU head state before passing
> > it to call_rcu() anyway. Only leave the "on_stack" variants so debugobjects can
> > keep track of objects on stack.
> > 
> > This patch applies to current -tip based on 2.6.34-rc2.
> 
> Reviewed-by: James Morris <jmorris@namei.org>

Thank you, James!

							Thanx, Paul
