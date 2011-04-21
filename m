Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab1DUNR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:17:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59129 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab1DUNR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:17:56 -0400
Date: Thu, 21 Apr 2011 15:17:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, Lin Ming <ming.m.lin@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: P4 PMU - Don't forget to clear
 cpuc->active_mask on overflow
Message-ID: <20110421131748.GB1642@elte.hu>
References: <4DAEF821.4050103@openvz.org>
 <20110421125345.GC31724@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421125345.GC31724@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> On Wed, Apr 20, 2011 at 07:13:37PM +0400, Cyrill Gorcunov wrote:
> > It's not enough to simply disable event on overflow the cpuc->active_mask
> > should be cleared as well otherwise counter may stall in "active" even
> > in real being already disabled (which potentially may lead to the situation
> > that user may not use this counter further).
> 
> I also noticed this patch fixed some unknown NMIs on a P4 when I stressed
> the box
> 
> Acked-by: Don Zickus <dzickus@redhat.com>

Ok. Mind one of you resending all pending patches in this area, with all 
Acked-by's and Tested-by's in place?

I'd like to ask one more thing as well: please submit the patches in a single 
e-mail thread - i.e. with a proper 0/N and e-mail threading, so that anyone can 
see that they are a group of patches. Current submissions are various versions 
of patches with no clear grouping.

Thanks,

	Ingo
