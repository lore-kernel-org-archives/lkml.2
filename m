Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab0DUSqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 14:46:15 -0400
Received: from mail-va3.bigfish.com ([216.32.180.111]:50147 "EHLO
	mail50-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756183Ab0DUSqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 14:46:14 -0400
X-Greylist: delayed 1172 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Apr 2010 14:46:14 EDT
X-SpamScore: -22
X-BigFish: VPS-22(zz1432P98dN936eM62a3Lzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0L18OK3-01-2DQ-02
X-M-MSG: 
Date: Wed, 21 Apr 2010 20:26:29 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/12] perf: introduce model specific events and AMD IBS
Message-ID: <20100421182629.GE6450@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
 <1271317461.32749.67.camel@laptop>
 <20100415151633.GN11907@erda.amd.com>
 <1271851865.4807.10284.camel@twins>
 <u2kbd4cb8901004210621gd8b453cg6b41f1ee3effaa99@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <u2kbd4cb8901004210621gd8b453cg6b41f1ee3effaa99@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Apr 2010 18:26:29.0617 (UTC) FILETIME=[292A1E10:01CAE180]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.04.10 15:21:35, Stephane Eranian wrote:
> Okay, so you're suggesting everything is exposed via PERF_SAMPLE_REGS.
> PEBS does capture machine state which is easily mapped onto PERF_SAMPLE_REGS.
> Well, that's until you look at PEB-LL on Nehalem where is captures
> latencies and data
> addresses.
>
> Those could be funneled through PERF_SAMPLE_REGS
> as well, I believe. But that means, PERF_SAMPLE_REGS would need some
> configuration
> bitmask to name the registers of interest, e.g. EAX, EDX, IBSOP_DATA,
> IBSOP_PHYSAD,
> and so on.

What is the idea of PERF_SAMPLE_REGS? A git grep PERF_SAMPLE_REGS only
returns a single line in -tip. I know nothing about it.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

