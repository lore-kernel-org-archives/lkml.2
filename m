Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab0GURYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:24:40 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:45028
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464Ab0GURYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:24:38 -0400
X-SpamScore: -28
X-BigFish: VPS-28(zz1432N98dN936eM4015L9371Pzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L5X4CQ-02-3GS-02
X-M-MSG: 
Date: Wed, 21 Jul 2010 19:24:28 +0200
From: Robert Richter <robert.richter@amd.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] x86, xsave: some code cleanups and reworks
Message-ID: <20100721172428.GS26154@erda.amd.com>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
 <20100720192717.GC6227@lenovo>
 <20100720194606.GO26154@erda.amd.com>
 <20100720200729.GD6227@lenovo>
 <20100720201740.GE6227@lenovo>
 <4C472123.1090900@zytor.com>
 <20100721165211.GD8009@lenovo>
 <20100721170124.GE8009@lenovo>
 <4C472A5C.50004@zytor.com>
 <20100721171718.GF8009@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100721171718.GF8009@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.07.10 13:17:18, Cyrill Gorcunov wrote:
> On Wed, Jul 21, 2010 at 10:11:56AM -0700, H. Peter Anvin wrote:
> > On 07/21/2010 10:01 AM, Cyrill Gorcunov wrote:
> > > 
> > > Peter, also I think such tuning must be done at merge window time only,
> > > just to not break other's patch queues.
> > > 
> > 
> > Realistically it should be done right after the merge window for the
> > *next* merge window.
> > 
> > 	-hpa
> >
> 
> ok, which means Robert should use old conventional test at the moment
> instead of introducing is_boot_cpu I suppose.

Yes, I am just using:

if (!smp_processor_id())
	...

Cyrill, if you like, I will leave it up to you to introduce the
is_boot_cpu() macro.

I still have patch 7/7 in my new posting in that removes the
boot_cpu_id. If your patch comes soon this will be obsolete as all
places will have the macro then.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

