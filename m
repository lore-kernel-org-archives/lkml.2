Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab1HAF4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 01:56:01 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:55528 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab1HAFzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 01:55:55 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zz936eK179dN1432N98dKzz1202hzzz32i668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LP8J4R-01-0JS-02
X-M-MSG: 
Date: Mon, 1 Aug 2011 07:55:40 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] perf, x86: Implement 64 bit counter support for IBS
Message-ID: <20110801055540.GA4590@erda.amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
 <1311860812-28748-8-git-send-email-robert.richter@amd.com>
 <1311958728.5890.412.camel@twins>
 <1311958962.5890.416.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1311958962.5890.416.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.07.11 13:02:42, Peter Zijlstra wrote:
> On Fri, 2011-07-29 at 18:58 +0200, Peter Zijlstra wrote:
> > On Thu, 2011-07-28 at 15:46 +0200, Robert Richter wrote:
> > > This patch implements 64 bit counter support for IBS. The sampling
> > > period is no longer limited to the hw counter width.
> > 
> > That should never be the case, even for shorter hw counter, in such a
> > case you should ignore overflows until you reach the programmed period.
> 
> Hmm, I might have mis-understood, is that exactly what this patch
> implements, or does this patch add support for new hardware?

Yes, this patch implements 64 bit counter in software and doesn't add
a new hardware feature. It implements 64 bit counting by throwing away
interrupts if the period isn't reached.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

