Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2LQU7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 15:59:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab2LQU7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 15:59:35 -0500
Date: Mon, 17 Dec 2012 12:59:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Thompson <set.mailinglist@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: build warning after merge of the final tree
Message-Id: <20121217125933.ec758888.akpm@linux-foundation.org>
In-Reply-To: <20121217143415.252a2f60076d1ba03807df55@canb.auug.org.au>
References: <20121217142238.a0840563304419bb345ac25f@canb.auug.org.au>
	<20121217143415.252a2f60076d1ba03807df55@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012 14:34:15 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> On Mon, 17 Dec 2012 14:22:38 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the final tree, today's linux-next build (powerpc allnoconfig)
> > produced this warning:
> > 
> > warning: (PPC) selects SPARSE_IRQ which has unmet direct dependencies (HAVE_GENERIC_HARDIRQS && (IRQ_DOMAIN && DEBUG_FS || MAY_HAVE_SPARSE_IRQ))
> > 
> > I don't know what introduced that.
> 
> Actually probably caused by commit a1eaa3bc8247 ("Kconfig: fix Irq
> Subsystem menu") from the akpm tree.

kconfig-fix-irq-subsystem-menu.patch was causing various problems so I
have dropped it.

