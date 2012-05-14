Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab2ENNMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:12:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:56300 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab2ENNMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:12:40 -0400
Message-ID: <1337001125.2443.26.camel@twins>
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.5
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        dipankar@in.ibm.com, pascal.chapperon@wanadoo.fr, davej@redhat.com,
        michel@digirati.com.br, joern@purestorage.com, jengelh@medozas.de,
        efault@gmx.de, sivanich@sgi.com, torvalds@linux-foundation.org,
        laijs@cn.fujitsu.com
Date: Mon, 14 May 2012 15:12:05 +0200
In-Reply-To: <20120511184236.GA10133@linux.vnet.ibm.com>
References: <20120511184236.GA10133@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-11 at 11:42 -0700, Paul E. McKenney wrote:
> 4.      Lai Jiangshan's algorithmic implementation of SRCU, which includes
>         call_srcu() and srcu_barrier().  A major feature of this new
>         implementation is that synchronize_srcu() no longer disturbs
>         the execution of other CPUs.  This work is based on earlier
>         implementations by Peter Zijlstra and myself.  Posted to
>         LKML: https://lkml.org/lkml/2012/2/22/82. 

Great, thanks! I've been manually merging rcu/srcu for a while, I guess
I can stop doing that now.
