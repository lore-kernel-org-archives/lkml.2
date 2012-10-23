Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab2JWOLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:11:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59934 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2JWOLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:11:23 -0400
Date: Tue, 23 Oct 2012 16:11:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 05/34] perf, x86: Report PEBS event in a raw format
Message-ID: <20121023141122.GI16230@one.firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org> <1350602382-12771-6-git-send-email-andi@firstfloor.org> <1350995474.13456.12.camel@twins> <CABPqkBQ4WkVb8cUdrACG8sFH7PDe96devv5_FiRSfDrxFMB8Zg@mail.gmail.com> <20121023134505.GD16230@one.firstfloor.org> <CABPqkBQiF7OG_rZKkafRuk700ryHi_h_yM7jHh1RLu4k23gW8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQiF7OG_rZKkafRuk700ryHi_h_yM7jHh1RLu4k23gW8A@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... NIH snipped ... 

> If you do this inside perf, you have access to more infrastructure
> code, e.g., dwarf.
> For instance, I am interested in getting a value profiling mode. That
> means sampling
> the values of function arguments. That needs some dwarf support and the PEBS
> machine state. With that you can produce a per function histogram of
> the 6 integer
> register args. You can certainly build anything in Python, but I don't
> see the point
> of this. Especially given that there is already some infrastructure
> (and abstraction)
> provided by Jiri's patch for PERF_SAMPLE_REGS.

Ok so please post some code for this.

I'm sure all your unwritten code is far greater than our written code
posted on mailing lists, but it's not a very useful discussion this way.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
