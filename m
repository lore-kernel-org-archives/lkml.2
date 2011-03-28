Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab1C1QXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:23:35 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:46200 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754338Ab1C1QXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:23:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Pko1oMtMyKeaFQfbkzP2SyuZmBQZMfxtfi3oxAMN0OQas+yNOLggpgs6w+kDFwXRRvVGacv650TvQUieOVhgbEbynxejDRc869JcvFVnlNLZwcpIF9pOVIStWKabh/fM;
Date: Mon, 28 Mar 2011 09:23:29 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Remove dma32_reserve_bootmem
Message-ID: <20110328092329.6e5ac682@jbarnes-desktop>
In-Reply-To: <20110328162213.GA20191@elte.hu>
References: <4D8AD6E0.10307@kernel.org>
	<20110324080326.GA30812@elte.hu>
	<20110328091946.7ab9165f@jbarnes-desktop>
	<20110328162213.GA20191@elte.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 18:22:13 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > On Thu, 24 Mar 2011 09:03:26 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Yinghai Lu <yinghai@kernel.org> wrote:
> > > 
> > > > 
> > > > That is workaround for holding dma32 buf when early bootmem could use up
> > > > those range on system that have lots of RAM.
> > > > 
> > > > Now x86 is using memblock, and even nobootmem wrapper do top-down allocation.
> > > > 
> > > > So We could remove those not needed code now.
> > > > 
> > > > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > > > 
> > > > ---
> > > >  arch/x86/include/asm/pci.h |    2 -
> > > >  arch/x86/kernel/pci-dma.c  |   64 ---------------------------------------------
> > > >  arch/x86/kernel/setup.c    |    1
> > > >  3 files changed, 67 deletions(-)
> > > 
> > > Cc:-ing Jesse - i suspect this should be handled by the PCI tree.
> > 
> > Please re-send, sounds good in theory but I'd like to see the patch.
> 
> It should be in your lkml folder, the first mail in this thread has the patch.

If I kept everything in my lkml folder maybe... :)

-- 
Jesse Barnes, Intel Open Source Technology Center
