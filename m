Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab0GAN7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:59:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:34660 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab0GAN66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:58:58 -0400
Subject: Re: [PATCH repost] sched: export sched_set/getaffinity to modules
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Sridhar Samudrala <sri@us.ibm.com>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
       Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@linux.intel.com>
In-Reply-To: <20100701133956.GD32223@redhat.com>
References: <20100625101022.GA16321@redhat.com>
	 <20100701110708.GA27368@redhat.com> <1277983179.1917.10.camel@laptop>
	 <1277984603.1917.15.camel@laptop> <20100701115507.GA31333@redhat.com>
	 <20100701122340.GB31333@redhat.com> <1277987657.1917.32.camel@laptop>
	 <1277988395.1917.47.camel@laptop> <20100701130816.GB32223@redhat.com>
	 <1277991024.1917.108.camel@laptop>  <20100701133956.GD32223@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 01 Jul 2010 15:57:45 +0200
Message-ID: <1277992665.1917.138.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 16:39 +0300, Michael S. Tsirkin wrote:
> 
> The proposed patch kills the thread when the fd is closed,
> so I think this already works without making it part of the process.
> 
OK, fd bound resources are fine.
