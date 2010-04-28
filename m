Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab0D1Qe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 12:34:28 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:15123
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755638Ab0D1Qe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 12:34:27 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz98dN936eM62a3Lzz1202hzz6ff19hz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L1LI0Y-01-AWP-02
X-M-MSG: 
Date: Wed, 28 Apr 2010 18:16:59 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Stephane Eranian <eranian@google.com>
Subject: Re: [osrc-patches] [PATCH 00/12] perf: introduce model specific
 events and AMD IBS
Message-ID: <20100428161659.GA20783@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 28 Apr 2010 16:17:00.0192 (UTC) FILETIME=[3B1E3200:01CAE6EE]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.04.10 22:23:09, Robert Richter wrote:
> This patch series introduces model specific events and impments AMD
> IBS (Instruction Based Sampling) for perf_events.

Peter,

I suggest to apply patches 1, 2, 3, 5, 6 to tip/perf/core if you don't
have objections. I will then resubmit a new version of all remaining
patches.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

