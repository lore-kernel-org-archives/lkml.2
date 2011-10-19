Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab1JSQxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:53:48 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:53042
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349Ab1JSQxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:53:47 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz936eK1432N98dK4015Lzz1202hzzz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LTBO96-01-AUC-02
X-M-MSG: 
Date: Wed, 19 Oct 2011 18:52:52 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 5/5] oprofile, x86: Reimplement nmi timer mode using perf
Message-ID: <20111019165252.GH24346@erda.amd.com>
References: <1318861624-715-1-git-send-email-robert.richter@amd.com>
 <1318861624-715-6-git-send-email-robert.richter@amd.com>
 <1318935581.21167.13.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1318935581.21167.13.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.10.11 06:59:41, Peter Zijlstra wrote:
> On Mon, 2011-10-17 at 16:27 +0200, Robert Richter wrote:
> > The legacy x86 nmi watchdog code was removed with the implementation
> > of the perf based nmi watchdog. This broke Oprofile's nmi timer
> > mode. To run nmi timer mode we relied on a continuous ticking nmi
> > source which the nmi watchdog provided. The nmi tick was no longer
> > available and current watchdog can not be used anymore since it runs
> > with very long periods in the range of seconds. This patch
> > reimplements the nmi timer mode using a perf counter nmi source.
> 
> fair enough,
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> I take it you'll take this through your oprofile tree?

Yes, will send it through my tree.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

