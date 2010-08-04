Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab0HDK3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 06:29:24 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:27329
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932075Ab0HDK3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 06:29:22 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz1432N98dN936eMzz1202hzzz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L6MIGM-02-067-02
X-M-MSG: 
Date: Wed, 4 Aug 2010 12:29:10 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: A question of perf NMI handler
Message-ID: <20100804102910.GI26154@erda.amd.com>
References: <1280913670.20797.179.camel@minggr.sh.intel.com>
 <20100804100116.GH26154@erda.amd.com>
 <1280917458.1923.937.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1280917458.1923.937.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.08.10 06:24:18, Peter Zijlstra wrote:
> On Wed, 2010-08-04 at 12:01 +0200, Robert Richter wrote:
> > To ensure that all other nmi handlers are
> > called, the perfctr's nmi handler must have the lowest priority. Then,
> > the handler will be the last in the chain. 
> 
> Well, unless another NMI handler has the exact same issue and also
> starts eating all NMIs, just in case.

In this case we will have to change the implementation for unhandled
nmis. But I don't know of other sources with this issue.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

