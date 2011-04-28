Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526Ab1D1WQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 18:16:42 -0400
Received: from aspirin.dii.utk.edu ([160.36.0.81]:46084 "EHLO
	aspirin.dii.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab1D1WQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 18:16:41 -0400
Date: Thu, 28 Apr 2011 18:16:22 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Ingo Molnar <mingo@elte.hu>
cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
In-Reply-To: <20110427065241.GF17079@elte.hu>
Message-ID: <alpine.DEB.2.00.1104281811400.25779@cl320.eecs.utk.edu>
References: <1303407662-15564-1-git-send-email-acme@infradead.org> <1303407662-15564-2-git-send-email-acme@infradead.org> <20110422063429.GA16643@elte.hu> <20110422080604.GA22611@elte.hu> <alpine.DEB.2.00.1104251307010.12389@cl320.eecs.utk.edu>
 <20110425175444.GC28239@elte.hu> <alpine.DEB.2.00.1104251736220.12389@cl320.eecs.utk.edu> <20110426073847.GB30630@elte.hu> <alpine.DEB.2.00.1104261648400.32482@cl320.eecs.utk.edu> <20110427065241.GF17079@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011, Ingo Molnar wrote:

> Secondly, you are still quite wrong even with your revised opinion. Being able 
> to type '-e cycles' and '-e instructions' in perf and get ... cycles and 
> instructions counts/events, and the kernel helping that kind of approach is not 
> 'abstraction to the extreme', it's called 'common sense'.

by your logic I should be able to delete a file by saying
  echo "delete /tmp/tempfile" > /dev/sdc1
because using unlink() is too low of an abstraction and confusing to the 
user.

> The fact that perfmon and oprofile works via magic vendor-specific event string 
> incantations is one of the many design failures of those projects - not a 
> virtue.

Well we disagree.  I think one of perf_events biggest failings (among 
many) is that these generalized event definitions are shoved into the 
kernel.  At least it bloats the kernel in an option commonly turned on by 
vendors.  At worst it gives users a full sense of security in thinking 
these counters are A). Portable across architectures and B). Actually 
measure what they say they do.

I know it is fun to reinvent the wheel, but you ignored decades of 
experience in dealing with perf-counters when you ran off and invented 
perf_events.  It will bite you eventually.

Vince
