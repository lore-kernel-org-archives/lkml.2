Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab1ADODH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:03:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:46685 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1ADODF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:03:05 -0500
Subject: Re: [PATCH 7/7] perf: Add load latency monitoring on Intel
 Nehalem/Westmere v2
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1294142361.2016.131.camel@laptop>
References: <1293464397.2695.109.camel@localhost>
	 <1294142361.2016.131.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 Jan 2011 15:03:24 +0100
Message-ID: <1294149804.2016.142.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 12:59 +0100, Peter Zijlstra wrote:
> 
> Right, so I think I want this in 3 patches, one adding the load-latency
> extra reg thing and PERF_SAMPLE_ADDR usage, one adding
> PERF_SAMPLE_LATENCY and one adding PERF_SAMPLE_EXTRA, I really dislike
> the LATENCY_DATA name since that ties the extra data to the latency
> thing, which isn't at all true for other platforms.

Also, this wants a 4th patch to be fully mergable, we want to have
tools/perf/ support for these things..
