Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab2BVJvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 04:51:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60273 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab2BVJvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 04:51:39 -0500
Message-ID: <1329904253.24994.1.camel@twins>
Subject: Re: [PATCH 2/3 RFC paul/rcu/srcu] srcu: only increase the upper bit
 for srcu_read_lock()
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Date: Wed, 22 Feb 2012 10:50:53 +0100
In-Reply-To: <4F44B57C.3020104@cn.fujitsu.com>
References: <20120213020951.GA12138@linux.vnet.ibm.com>
	 <4F41F315.1040900@cn.fujitsu.com>
	 <20120220174418.GI2470@linux.vnet.ibm.com>
	 <4F42EF53.6060400@cn.fujitsu.com>
	 <20120221015037.GE2384@linux.vnet.ibm.com>
	 <4F435966.9020106@cn.fujitsu.com>
	 <20120221172442.GG2375@linux.vnet.ibm.com>
	 <4F44B57C.3020104@cn.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-22 at 17:29 +0800, Lai Jiangshan wrote:
> +       ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) += -1;

That just looks funny.. 
