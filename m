Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab0ETOI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 10:08:27 -0400
Received: from mail-va3.bigfish.com ([216.32.180.116]:34404 "EHLO
	mail46-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752571Ab0ETOI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 10:08:26 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz98dN936eM62a3Lzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0L2Q1XT-01-49Q-02
X-M-MSG: 
Date: Thu, 20 May 2010 16:08:19 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       David Miller <davem@davemloft.net>, Will Deacon <will.deacon@arm.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/7] perf: introduce raw_type attribute to specify the
 type of a raw sample
Message-ID: <20100520140819.GQ21799@erda.amd.com>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
 <1274304024-6551-2-git-send-email-robert.richter@amd.com>
 <AANLkTiniEWKJIrbTSZQ0jBXps75WVQbvGSXVyUVttJ7P@mail.gmail.com>
 <1274347413.5605.13636.camel@twins>
 <AANLkTikWSOPpHsvJGht7c7QnwcOk-nMyBNhY-g6QpNzg@mail.gmail.com>
 <1274351859.5605.13961.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1274351859.5605.13961.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.05.10 06:37:39, Peter Zijlstra wrote:

> So yeah, you might as well expose it as a whole separate PMU using Lin's
> stuff.

This seems to be the most promising alternative to raw_type. But it's
also much more bloated requiring sysfs and additional file
descriptors.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

