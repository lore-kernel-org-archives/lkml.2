Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab2CRHTb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 03:19:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:39206 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753006Ab2CRHTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 03:19:30 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19+H8AgX35+96CF57BcWMK8dEOFGUfvG9YSqOyTW2
	uR05wgcWy/f0WN
Message-ID: <1332055160.7291.7.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] rcu: Permit limiting of force_quiescent_state()
 latency
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sivanich@sgi.com
Date: Sun, 18 Mar 2012 08:19:20 +0100
In-Reply-To: <1332003451.8147.77.camel@marge.simpson.net>
References: <20120316160328.GA7207@linux.vnet.ibm.com>
	 <1332003451.8147.77.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-17 at 17:57 +0100, Mike Galbraith wrote:

> So I bent it up a little, see below.

s/bent/busted.  FQS_MAX_CPU_VISIT < CPUs == deadlock.  Poo.

-Mike

