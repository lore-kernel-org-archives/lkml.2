Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab1KKOot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 09:44:49 -0500
Received: from mail-am1.bigfish.com ([213.199.180.138]:54730 "EHLO
	AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752789Ab1KKOor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 09:44:47 -0500
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Nov 2011 09:44:47 EST
X-SpamScore: -3
X-BigFish: VPS-3(zz98dKzz1202hzzz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LUI2XC-01-6Z7-02
X-M-MSG: 
Date: Fri, 11 Nov 2011 15:29:35 +0100
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
Message-ID: <20111111142935.GI15738@erda.amd.com>
References: <20111107110149.GA5177@quad>
 <20111110180308.GD15738@erda.amd.com>
 <1320951167.13800.50.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1320951167.13800.50.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.11.11 19:52:47, Peter Zijlstra wrote:
> IIRC, Robert's proposal limits the rewind stack to 1, which, if my mind
> didn't completely stop working, should end up being something like
> O(n^3). Now I don't know if Robert's thing is perfect for AMD F15 or if
> there's still some odd fail cases, but since he's from AMD I suspect its
> good enough in practice.

Yes, patches are ok for AMD F15.

> In fact, I almost merged his code, my only complaint was a lack of
> comments and having had to spend several hours to fully understand the
> thing a few months ago, I felt it really could use some since I didn't
> want to have to spend that amount of effort every time I'd have to look
> at the thing.

Will repost an updated version.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

