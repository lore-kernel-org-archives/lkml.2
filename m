Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab1LFJtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:49:35 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42708 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933026Ab1LFJtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:49:33 -0500
Date: Tue, 6 Dec 2011 09:49:28 +0000
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "acme@redhat.com" <acme@redhat.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "ravitillo@lbl.gov" <ravitillo@lbl.gov>,
        "paulus@samba.org" <paulus@samba.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>
Subject: Re: [PATCH 00/12] perf_events: add support for sampling taken
 branches (v2)
Message-ID: <20111206094927.GA25782@mudshark.cambridge.arm.com>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
 <1323124766.32012.49.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323124766.32012.49.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 10:39:26PM +0000, Peter Zijlstra wrote:
> On Fri, 2011-10-14 at 14:37 +0200, Stephane Eranian wrote:
> > This patchset adds an important and useful new feature to
> > perf_events: branch stack sampling. In other words, the
> > ability to capture taken branches into each sample.
> > 
> Other than the few comments given it all looks good. My main worry is
> the Intel only aspect, I'd really love for there to be another platform
> that could implement at least part of this.

I discussed this with Stephane in Prague and, although it would be lovely to
have this on ARM, we simply don't have the hardware to do it. So the nature
of series does seem to be x86-centric unless there's way to do a watered
down version in software.

Will
