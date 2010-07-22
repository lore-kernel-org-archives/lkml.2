Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339Ab0GVNQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 09:16:32 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:27889
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753345Ab0GVNQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 09:16:31 -0400
X-SpamScore: -24
X-BigFish: VPS-24(zz1432N98dN936eM9371Pzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L5YNJ7-02-5SF-02
X-M-MSG: 
Date: Thu, 22 Jul 2010 15:16:21 +0200
From: Robert Richter <robert.richter@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] x86, xsave: introduce xstate enable functions
Message-ID: <20100722131621.GY26154@erda.amd.com>
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
 <1279731838-1522-3-git-send-email-robert.richter@amd.com>
 <4C476236.1020302@zytor.com>
 <1279747225.2812.37.camel@sbs-t61.sc.intel.com>
 <4C476C5B.8020604@zytor.com>
 <20100722121522.GT26154@erda.amd.com>
 <4C48385C.9040309@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C48385C.9040309@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.07.10 08:23:56, H. Peter Anvin wrote:
> On 07/22/2010 05:15 AM, Robert Richter wrote:
> > 
> > Just wondering why you are using this_func()? Instead, you could
> > simply do:
> > 
> > 	next_func();
> > 	next_func = xstate_enable;
> > 
> > Do you see races when bringing up multiple cpus in parallel?
> > 
> 
> It allows the compiler to turn it into a tailcall if frame pointers are
> disabled.

Yes, that makes sense.

Thanks.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

