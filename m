Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab2E2FUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 01:20:52 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:10605 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2E2FUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 01:20:50 -0400
Date: Tue, 29 May 2012 07:20:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (sparc
	tree related)
Message-ID: <20120529052048.GA20846@merkur.ravnborg.org>
References: <20120529150937.3e643f49e030becbc02c11c6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120529150937.3e643f49e030becbc02c11c6@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 03:09:37PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
> 
> In file included from arch/sparc/kernel/prom_common.c:26:0:
> arch/sparc/include/asm/leon.h:221:9: error: unknown type name 'irq_flow_handler_t'
> arch/sparc/include/asm/leon.h:224:10: error: unknown type name 'irq_flow_handler_t'
> 
> Maybe caused by commit 93bb32f632c9 ("sparc32,leon: clean up leon.h")
> which exposed much more of the header file.
Most likely.

> 
> I am not sure what to do to fix this, so I have left it broken for today.
I wlll take a look tonight.
I would prefer that this header file is not exposed to sparc64..

	Sam
