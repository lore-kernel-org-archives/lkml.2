Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab0HCB4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 21:56:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:33434 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab0HCB42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 21:56:28 -0400
Subject: Re: linux-next: build failure after merge of the final tree (tip
 tree related)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20100802162810.GB4755@flint.arm.linux.org.uk>
References: <20100803022310.bec3ba79.sfr@canb.auug.org.au>
	 <20100802162810.GB4755@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 11:42:04 +1000
Message-ID: <1280799724.1902.84.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Please, no, don't break the memblock code now.  I'm not reworking the
> ARM implementation just as the merge window has opened - especially
> as the ARM implementation has now been pulled into other people's
> trees.
> 
> If there's changes to memblock which haven't been in linux-next (which,
> as this is a new failure, that is most definitely the case), then they
> shouldn't be going into this merge window.

I'm happy to wait and sit on the memblock churn until after ARM's in.

I can then fixup my patches.

Cheers,
Ben.

