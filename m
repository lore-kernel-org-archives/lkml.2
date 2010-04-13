Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab0DMUqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:46:38 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:35432 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab0DMUqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:46:37 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz98dN936eM62a3Lzz1202hzzz32i6bh467h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L0U1PH-01-DSG-02
X-M-MSG: 
Date: Tue, 13 Apr 2010 22:45:19 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Stephane Eranian <eranian@google.com>
Subject: Re: [osrc-patches] [PATCH 00/12] perf: introduce model specific
 events and AMD IBS
Message-ID: <20100413204519.GX11907@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 13 Apr 2010 20:45:20.0401 (UTC) FILETIME=[3B64E010:01CADB4A]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.04.10 22:23:09, Robert Richter wrote:
> This patch series introduces model specific events and impments AMD
> IBS (Instruction Based Sampling) for perf_events.

The patch set triggers this warning in perf_prepare_sample():

 WARN_ON_ONCE(size & (sizeof(u64)-1))

Should a raw data sample padded to 64 bit?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

