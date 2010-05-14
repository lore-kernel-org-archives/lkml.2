Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab0ENPH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 11:07:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59727 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517Ab0ENPH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 11:07:27 -0400
Subject: Re: [RFC] perf_events: ctx_flexible_sched_in() not maximizing PMU 
 utilization
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1273848908.1626.315.camel@laptop>
References: <AANLkTikQCkR2K438llKOh43yEgW-Bw7j0f8GoXR50A0V@mail.gmail.com>
	 <1273155640.5605.300.camel@twins> <20100506171141.GA5562@nowhere>
	 <1273167024.1642.256.camel@laptop> <1273220736.1642.318.camel@laptop>
	 <AANLkTimegTx_2wHCIhyLqcYbkIJEPi3SsdwgFxU4E7Rk@mail.gmail.com>
	 <1273226796.1642.333.camel@laptop>
	 <AANLkTimguldif-yCpPIPC65RL5bvp-HARuuhOHarxIf1@mail.gmail.com>
	 <1273230948.1642.351.camel@laptop>
	 <AANLkTimu41pPmimFK10oQl0_Qh07vc3pJbxwNp-jDtTM@mail.gmail.com>
	 <1273848908.1626.315.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 17:07:23 +0200
Message-ID: <1273849643.1626.316.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 16:55 +0200, Peter Zijlstra wrote:
> and selects between
> the two based on lag -- I'm not quite sure that that works out as
> expected though, still have to do the actual math.

Having had a bit of a think it doesn't sound right. I'll have to come up
with something else instead.

