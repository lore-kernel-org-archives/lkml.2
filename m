Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934111Ab0EDU1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:27:52 -0400
Received: from waste.org ([173.11.57.241]:52109 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934090Ab0EDU1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:27:11 -0400
Subject: Re: [PATCH tip/core/rcu 21/48] remove all rcu head
 initializations, except on_stack initializations
From: Matt Mackall <mpm@selenic.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
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
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>
In-Reply-To: <1273004398-19760-21-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20100504201934.GA19234@linux.vnet.ibm.com>
	 <1273004398-19760-21-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 15:27:03 -0500
Message-ID: <1273004823.21962.2278.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 13:19 -0700, Paul E. McKenney wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> 
> Remove all rcu head inits. We don't care about the RCU head state before passing
> it to call_rcu() anyway. Only leave the "on_stack" variants so debugobjects can
> keep track of objects on stack.

Please document that distinction at the definition of INIT_RCU_HEADS,
otherwise we're sure to see creep.

-- 
Mathematics is the supreme nostalgia of our time.


