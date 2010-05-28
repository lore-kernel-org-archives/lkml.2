Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399Ab0E1RgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 13:36:13 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:22705 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab0E1RgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 13:36:11 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432P98dN936eM62a3Lzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L354VW-01-KRC-02
X-M-MSG: 
Date: Fri, 28 May 2010 19:35:55 +0200
From: Robert Richter <robert.richter@amd.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] perf: align raw sample data on 64-bit boundaries
Message-ID: <20100528173555.GP21799@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
 <1271190201-25705-13-git-send-email-robert.richter@amd.com>
 <n2wbd4cb8901004190519m9c939c26wbe49701fdfd2379a@mail.gmail.com>
 <20100518151227.GJ21799@erda.amd.com>
 <20100519073908.GE5704@nowhere>
 <20100519093100.GL21799@erda.amd.com>
 <20100524212459.GA9707@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100524212459.GA9707@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.05.10 17:25:01, Frederic Weisbecker wrote:
> It doesn't duplicate much code paths, we only have a few corner cases to
> plug in. And more importantly, that would be temporary if we schedule the
> older PERF_SAMPLE_RAW in, say, three releases from now.
> 
> This ensures an easy forward compatibility (older perf tools -> newer kernel).
> But the backward compatibility is less easy (newer perf tools -> older kernel)
> as it means we need to test dynamically if we have PERF_SAMPLE_RAW_ALIGNED,
> otherwise we need to fall back to using the older one.

Frederic, I will send an updated version with PERF_SAMPLE_RAW_ALIGNED.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

