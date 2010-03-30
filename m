Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab0C3RYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 13:24:25 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:9447 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab0C3RYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 13:24:23 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zba6lz1432R98dN936eM62a3Lzz1202hzzz32i2a8h6bh43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L03V0C-02-OE7-02
X-M-MSG: 
Date: Tue, 30 Mar 2010 19:24:13 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 0/3] perf/core, x86: unify perfctr bitmasks
Message-ID: <20100330172413.GK11907@erda.amd.com>
References: <1269880612-25800-1-git-send-email-robert.richter@amd.com>
 <bd4cb8901003300311l4178891dvf1e63293a0ac51fe@mail.gmail.com>
 <20100330134145.GI11907@erda.amd.com>
 <bd4cb8901003300653lc8e414bp3930b03fee2fffbf@mail.gmail.com>
 <1269961255.5258.221.camel@laptop>
 <20100330155949.GJ11907@erda.amd.com>
 <1269968113.5258.442.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1269968113.5258.442.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 30 Mar 2010 17:24:14.0169 (UTC) FILETIME=[D1937C90:01CAD02D]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.03.10 18:55:13, Peter Zijlstra wrote:
> On Tue, 2010-03-30 at 17:59 +0200, Robert Richter wrote:
> > > +     if (attr->type == PERF_TYPE_RAW)
> > > +             return x86_pmu.raw_event(event);
> > 
> > We could go on with this and move this into *_hw_config(), but so far
> > this change is fine to me. This would then remove .raw_event() at all.
> > 
> 
> Right, I did have a brief look at that, you mentioned this before to
> Cyrill IIRC, but the issue is that... ~brainwave~ how about the below..

I like your patch, thanks Peter.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

