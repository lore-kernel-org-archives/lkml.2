Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab0ETQzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 12:55:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54108 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab0ETQzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 12:55:41 -0400
Date: Thu, 20 May 2010 18:55:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       David Miller <davem@davemloft.net>, Will Deacon <will.deacon@arm.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/7] perf: introduce raw_type attribute to specify the
 type of a raw sample
Message-ID: <20100520165501.GA8281@elte.hu>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
 <1274304024-6551-2-git-send-email-robert.richter@amd.com>
 <AANLkTiniEWKJIrbTSZQ0jBXps75WVQbvGSXVyUVttJ7P@mail.gmail.com>
 <1274347413.5605.13636.camel@twins>
 <AANLkTikWSOPpHsvJGht7c7QnwcOk-nMyBNhY-g6QpNzg@mail.gmail.com>
 <1274351859.5605.13961.camel@twins>
 <20100520140819.GQ21799@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100520140819.GQ21799@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0225]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> On 20.05.10 06:37:39, Peter Zijlstra wrote:
> 
> > So yeah, you might as well expose it as a whole separate PMU using Lin's 
> > stuff.
> 
> This seems to be the most promising alternative to raw_type. But it's also 
> much more bloated requiring sysfs and additional file descriptors.

Not really, fds are really cheap on Linux, and in any case it's only needed 
when the event is created - can be closed afterwards.

	Ingo
