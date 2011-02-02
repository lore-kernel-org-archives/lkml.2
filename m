Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab1BBWiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:38:07 -0500
Received: from www.tglx.de ([62.245.132.106]:36900 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155Ab1BBWiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:38:04 -0500
Date: Wed, 2 Feb 2011 23:37:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg Ungerer <gerg@snapgear.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [patch 7/8] m68knommu: 5772: Replace private irq flow handler
In-Reply-To: <4D49DA5B.10308@snapgear.com>
Message-ID: <alpine.LFD.2.00.1102022336090.31804@localhost6.localdomain6>
References: <20110202212258.546660886@linutronix.de> <20110202212552.413849952@linutronix.de> <4D49DA5B.10308@snapgear.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011, Greg Ungerer wrote:

> 
> Hi Thomas,
> 
> On 03/02/11 07:41, Thomas Gleixner wrote:
> > That handler lacks the minimal checks for action being zero etc. Keep
> > the weird flow - ack before handling - intact and call into
> > handle_simple_irq which does the right thing.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Greg Ungerer <gerg@uclinux.org>
> 
> Acked-by: Greg Ungerer <gerg@uclinux.org>
> 
> (I can't test this change for a week or two at least, I don't
> have access to any 5272 based boards at the moment.)
> 
> Do you want me to push it through the m68knommu tree,
> or are you going to do that yourself?

If it does not conflict with your stuff, I'd prefer to push it myself,
so I can apply the depending patches as well.

Thanks,

	tglx
