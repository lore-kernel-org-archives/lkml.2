Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab0DNMb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 08:31:29 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:4461 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab0DNMb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 08:31:27 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432P98dN936eM62a3Lzz1202hzzz32i2a8h467h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L0V9G3-01-ABX-02
X-M-MSG: 
Date: Wed, 14 Apr 2010 14:31:13 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Stephane Eranian <eranian@google.com>
Subject: Re: [osrc-patches] [PATCH 00/12] perf: introduce model specific
 events and AMD IBS
Message-ID: <20100414123113.GY11907@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
 <20100413204519.GX11907@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100413204519.GX11907@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 14 Apr 2010 12:31:14.0129 (UTC) FILETIME=[5F408410:01CADBCE]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.04.10 22:45:19, Robert Richter wrote:
> On 13.04.10 22:23:09, Robert Richter wrote:
> > This patch series introduces model specific events and impments AMD
> > IBS (Instruction Based Sampling) for perf_events.
> 
> The patch set triggers this warning in perf_prepare_sample():
> 
>  WARN_ON_ONCE(size & (sizeof(u64)-1))

Just found Stephane's patch on the mailing list that removes the warning.

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

