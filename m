Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab0ETRHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 13:07:24 -0400
Received: from mail-va3.bigfish.com ([216.32.180.114]:53879 "EHLO
	mail44-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752611Ab0ETRHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 13:07:23 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz98dN936eM62a3Lzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0L2QA7Y-01-IV3-02
X-M-MSG: 
Date: Thu, 20 May 2010 19:07:12 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       David Miller <davem@davemloft.net>, Will Deacon <will.deacon@arm.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/7] perf: introduce raw_type attribute to specify the
 type of a raw sample
Message-ID: <20100520170712.GV21799@erda.amd.com>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
 <1274304024-6551-2-git-send-email-robert.richter@amd.com>
 <AANLkTiniEWKJIrbTSZQ0jBXps75WVQbvGSXVyUVttJ7P@mail.gmail.com>
 <1274347413.5605.13636.camel@twins>
 <AANLkTikWSOPpHsvJGht7c7QnwcOk-nMyBNhY-g6QpNzg@mail.gmail.com>
 <1274351859.5605.13961.camel@twins>
 <20100520140819.GQ21799@erda.amd.com>
 <20100520165501.GA8281@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100520165501.GA8281@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.05.10 12:55:01, Ingo Molnar wrote:
> Not really, fds are really cheap on Linux, and in any case it's only needed 
> when the event is created - can be closed afterwards.

I was wondering if we could get the perf event fd directly with the
open("/sys/...") command? This would be really easy to set up.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

