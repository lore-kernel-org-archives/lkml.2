Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab0FNJXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 05:23:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52131 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755822Ab0FNJXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 05:23:30 -0400
Subject: Re: perf_disable()
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1276273784.2077.2055.camel@twins>
References: <1276273784.2077.2055.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jun 2010 10:23:11 +0100
Message-ID: <1276507391.5601.2.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jun 2010 09:23:16.0081 (UTC) FILETIME=[3835B610:01CB0BA3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, 2010-06-11 at 17:29 +0100, Peter Zijlstra wrote:
> Hi,
> 
> I've been going over perf_disable() usage in kernel/perf_event.c and
> wondered if we actually need it at all.

-------->8--------

> If nobody else known about/can find anything, I'm going to mostly remove
> perf_disable() for now and later think about how to optimize the
> hardware writes again.

No objections from the ARM camp as we don't use perf_disable() for
anything anyway.

Will


