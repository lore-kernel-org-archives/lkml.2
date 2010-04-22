Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797Ab0DVVMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 17:12:35 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:53222 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab0DVVMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 17:12:32 -0400
Date: Thu, 22 Apr 2010 14:12:12 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/5] sched: Fix an RCU warning in print_task()
Message-ID: <20100422211212.GA32490@count0.beaverton.ibm.com>
References: <4BD016F4.8060108@cn.fujitsu.com>
 <4BD01740.7050805@cn.fujitsu.com>
 <1271931604.1776.337.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271931604.1776.337.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 12:20:04PM +0200, Peter Zijlstra wrote:

<snip>

> You can also pin a cgroup by holding whatever locks are held in the
> ->attach method. But the RCU annotation doesn't know (nor reasonably can
> know about that).

For my future reference, what's the right way to "fix" these
situations with the RCU annotations? (I think your response re: Li's
freezer patch was correct and illustrates the problem I'm referring to.)

Cheers,
	-Matt Helsley
