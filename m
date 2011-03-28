Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab1C1QTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:19:53 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:46510 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751744Ab1C1QTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:19:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=LqJ+6l3Aq21I6nTJYQ610yHkGjcoDkHXmc6iogSzKI3FqoKSa8KBh0hTu+e/L0vbikeXr+wfBWXpteIbBaOt9qiCEmC1oTMFtocp7gNBjgXn5oaO4kcz9N5mb2yUxFr/;
Date: Mon, 28 Mar 2011 09:19:46 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Remove dma32_reserve_bootmem
Message-ID: <20110328091946.7ab9165f@jbarnes-desktop>
In-Reply-To: <20110324080326.GA30812@elte.hu>
References: <4D8AD6E0.10307@kernel.org>
	<20110324080326.GA30812@elte.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 09:03:26 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > 
> > That is workaround for holding dma32 buf when early bootmem could use up
> > those range on system that have lots of RAM.
> > 
> > Now x86 is using memblock, and even nobootmem wrapper do top-down allocation.
> > 
> > So We could remove those not needed code now.
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > 
> > ---
> >  arch/x86/include/asm/pci.h |    2 -
> >  arch/x86/kernel/pci-dma.c  |   64 ---------------------------------------------
> >  arch/x86/kernel/setup.c    |    1
> >  3 files changed, 67 deletions(-)
> 
> Cc:-ing Jesse - i suspect this should be handled by the PCI tree.

Please re-send, sounds good in theory but I'd like to see the patch.

-- 
Jesse Barnes, Intel Open Source Technology Center
