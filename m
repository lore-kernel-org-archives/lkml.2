Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0ETRRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 13:17:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42469 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab0ETRRQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 13:17:16 -0400
Subject: Re: [PATCH 1/7] perf: introduce raw_type attribute to specify the
 type of a raw sample
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       David Miller <davem@davemloft.net>, Will Deacon <will.deacon@arm.com>,
       Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20100520170712.GV21799@erda.amd.com>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
	 <1274304024-6551-2-git-send-email-robert.richter@amd.com>
	 <AANLkTiniEWKJIrbTSZQ0jBXps75WVQbvGSXVyUVttJ7P@mail.gmail.com>
	 <1274347413.5605.13636.camel@twins>
	 <AANLkTikWSOPpHsvJGht7c7QnwcOk-nMyBNhY-g6QpNzg@mail.gmail.com>
	 <1274351859.5605.13961.camel@twins> <20100520140819.GQ21799@erda.amd.com>
	 <20100520165501.GA8281@elte.hu>  <20100520170712.GV21799@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 20 May 2010 19:16:35 +0200
Message-ID: <1274375795.5605.15313.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 19:07 +0200, Robert Richter wrote:
> On 20.05.10 12:55:01, Ingo Molnar wrote:
> > Not really, fds are really cheap on Linux, and in any case it's only needed 
> > when the event is created - can be closed afterwards.
> 
> I was wondering if we could get the perf event fd directly with the
> open("/sys/...") command? This would be really easy to set up.

I guess we could sorta do that, but then we'd need a ioctl to change the
perf_event_attr.
