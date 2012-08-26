Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab2HZJ4l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 05:56:41 -0400
Received: from 8bytes.org ([85.214.48.195]:35012 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab2HZJ4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 05:56:40 -0400
Date: Sun, 26 Aug 2012 11:56:36 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Joerg Roedel <joerg.roedel@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 03/19] x86, io_apic: Introduce x86_io_apic_ops.disable()
Message-ID: <20120826095636.GA17549@8bytes.org>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-4-git-send-email-joerg.roedel@amd.com>
 <20120823211140.GB7120@breakpoint.cc>
 <20120824122226.GW2582@amd.com>
 <20120825171705.GC3363@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120825171705.GC3363@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sun Aug 26 11:56:37 2012
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5039f2d522971562218834
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 07:17:05PM +0200, Sebastian Andrzej Siewior wrote:
> On Fri, Aug 24, 2012 at 02:22:26PM +0200, Joerg Roedel wrote:

> > Is it worth it to split that out?
> 
> I don't insist to redo the patch because of this. Please redo the patch
> description to better describe what you do. You pull the "irq remap" code out
> and stuff it in another function.

Okay, I will update the commit message :)


	Joerg


