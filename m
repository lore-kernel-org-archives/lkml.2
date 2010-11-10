Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab0KJPIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:08:42 -0500
Received: from canuck.infradead.org ([134.117.69.58]:44901 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab0KJPIl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:08:41 -0500
Subject: Re: [RFC PATCH 2/2] perf stat: Use event group to simulate PMI on
 PMI-less hardware counter
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Matt Fleming <matt@console-pimps.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1289401597.2479.48.camel@localhost>
References: <1289369725.2430.39.camel@minggr.sh.intel.com>
	 <1289391709.2191.102.camel@laptop>  <1289400319.2479.39.camel@localhost>
	 <1289400784.2191.134.camel@laptop>  <1289401597.2479.48.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 16:08:43 +0100
Message-ID: <1289401723.2084.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 23:06 +0800, Lin Ming wrote:
> > The proposed idea was to group with a software hrtimer-based event
> > and use the hrtimer's sample to read the hardware group sibling using
> > PERF_SAMPLE_READ.
> 
> So this is usefull in perf top/record on PMI-less counter?

Correct, Matt was implementing this.
