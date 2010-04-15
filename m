Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab0DOHlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:41:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:38034 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab0DOHlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:41:50 -0400
Subject: Re: [osrc-patches] [PATCH 00/12] perf: introduce model specific
 events and AMD IBS
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Stephane Eranian <eranian@google.com>
In-Reply-To: <20100413204519.GX11907@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
	 <20100413204519.GX11907@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Apr 2010 09:41:46 +0200
Message-ID: <1271317306.32749.64.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 22:45 +0200, Robert Richter wrote:
> On 13.04.10 22:23:09, Robert Richter wrote:
> > This patch series introduces model specific events and impments AMD
> > IBS (Instruction Based Sampling) for perf_events.
> 
> The patch set triggers this warning in perf_prepare_sample():
> 
>  WARN_ON_ONCE(size & (sizeof(u64)-1))
> 
> Should a raw data sample padded to 64 bit?

Yes it should.

