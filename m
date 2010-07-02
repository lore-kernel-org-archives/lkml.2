Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab0GBSLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 14:11:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34376 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab0GBSLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 14:11:43 -0400
Subject: Re: [PATCH repost] sched: export sched_set/getaffinity to modules
From: Peter Zijlstra <peterz@infradead.org>
To: Sridhar Samudrala <sri@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       "Michael S. Tsirkin" <mst@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
       Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@linux.intel.com>
In-Reply-To: <4C2E2987.9040702@us.ibm.com>
References: <1277983179.1917.10.camel@laptop>
	 <1277984603.1917.15.camel@laptop> <20100701115507.GA31333@redhat.com>
	 <20100701122340.GB31333@redhat.com> <1277987657.1917.32.camel@laptop>
	 <1277988395.1917.47.camel@laptop> <20100701130816.GB32223@redhat.com>
	 <1277991024.1917.108.camel@laptop> <20100701133956.GD32223@redhat.com>
	 <4C2CA5C5.4040402@kernel.org> <20100701144624.GA11171@redhat.com>
	 <4C2CABF2.2020801@kernel.org> <1277996135.1917.198.camel@laptop>
	 <4C2E2987.9040702@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 02 Jul 2010 20:11:10 +0200
Message-ID: <1278094270.1917.288.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-02 at 11:01 -0700, Sridhar Samudrala wrote:
>  
>  Does  it (Tejun's kthread_clone() patch) also  inherit the 
> cgroup of the caller?

Of course, its a simple do_fork() which inherits everything just as you
would expect from a similar sys_clone()/sys_fork() call.
