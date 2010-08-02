Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab0HBIEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:04:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:35455 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817Ab0HBIEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:04:21 -0400
Subject: Re: linux-next: build warnings after merge of the final tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100802141035.f84f9132.sfr@canb.auug.org.au>
References: <20100802141035.f84f9132.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 18:03:50 +1000
Message-ID: <1280736230.1902.56.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-02 at 14:10 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allnoconfig with CONFIG_DEBUG_SECTION_MISMATCH=y) produced these warnings:

 .../...

> Introduced by the memblock series in the tip tree.

Ok, so those are my fault but none are deadly. I'll do a fixup patch on
top of this.

Cheers,
Ben.


