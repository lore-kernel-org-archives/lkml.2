Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab0GAMel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 08:34:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39553 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab0GAMej convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 08:34:39 -0400
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
In-Reply-To: <20100701122340.GB31333@redhat.com>
References: <4BFFE742.2060205@kernel.org>
	 <20100530112925.GB27611@redhat.com> <4C02C99D.9070204@kernel.org>
	 <20100624081135.GA937@redhat.com>
	 <1277419551.27868.27.camel@w-sridhar.beaverton.ibm.com>
	 <20100625101022.GA16321@redhat.com> <20100701110708.GA27368@redhat.com>
	 <1277983179.1917.10.camel@laptop> <1277984603.1917.15.camel@laptop>
	 <20100701115507.GA31333@redhat.com>  <20100701122340.GB31333@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 01 Jul 2010 14:34:17 +0200
Message-ID: <1277987657.1917.32.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 15:23 +0300, Michael S. Tsirkin wrote:
> 
> The patch using this is here:
> http://www.mail-archive.com/kvm@vger.kernel.org/msg35411.html
> 
> It simply copies the affinity from the parent when thread is created.

Sounds like policy, not something the kernel should do..
