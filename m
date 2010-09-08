Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab0IHN5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:57:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:41587 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab0IHN5V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:57:21 -0400
Subject: Re: [RFC PATCH 1/2] perf_events: add support for per-cpu
 per-cgroup monitoring (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@gmail.com
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, robert.richter@amd.com, acme@redhat.com
In-Reply-To: <AANLkTikcJ3X0q8SXb55NbrFRd5GUVEXGzbePGUtxF+Wf@mail.gmail.com>
References: <4c8793a9.cde7d80a.3bb6.0290@mx.google.com>
	 <1283953967.23762.22.camel@laptop>
	 <AANLkTikcJ3X0q8SXb55NbrFRd5GUVEXGzbePGUtxF+Wf@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Sep 2010 15:57:01 +0200
Message-ID: <1283954221.23762.25.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-08 at 15:56 +0200, stephane eranian wrote:
> On Wed, Sep 8, 2010 at 3:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, 2010-09-08 at 15:30 +0200, Stephane Eranian wrote:
> >> +       } times[NR_CPUS] ____cacheline_aligned_in_smp;
> >
> > That's fail! NR_CPUS can be like 4k for distro configs.
> >
> How do you do this on struct that are dynamically allocated?
> The number of css is dynamic.

alloc_percpu()?
