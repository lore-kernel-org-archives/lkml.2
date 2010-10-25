Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab0JYJZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 05:25:28 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:28116 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab0JYJZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:25:27 -0400
Date: Mon, 25 Oct 2010 11:25:19 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: error importing i2c quilt series
Message-ID: <20101025112519.5d932562@endymion.delvare>
In-Reply-To: <20101025195349.f5ac62eb.sfr@canb.auug.org.au>
References: <20101025105900.83472a69.sfr@canb.auug.org.au>
	<20101025103404.73c24f45@endymion.delvare>
	<20101025195349.f5ac62eb.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Oct 2010 19:53:49 +1100, Stephen Rothwell wrote:
> Hi Jean,
> 
> On Mon, 25 Oct 2010 10:34:04 +0200 Jean Delvare <khali@linux-fr.org> wrote:
> >
> > This patch depends on a patch adding/updating PCI IDs which I thought
> > was in Jesse Barnes' pci tree which you also pull in linux-next.
> > Apparently my assumption was wrong.
> 
> Your series file says that your series is based on 2.6.36-git5, not
> Jesse's pci tree.  You can add:
> 
> # NEXT-BASE pci
> 
> to your series file to force me to import your series on top of Jesse's
> tree instead of 2.6.36-rc5.

I thought it was NEXT_BASE, with an underscore not dash?

And I also expected the trees to be merged in the order shows in:
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=blob;f=Next/Trees;hb=HEAD

As pci is listed before i2c, I (wrongly) concluded that everything
would be fine even without using NEXT_BASE. I stand corrected.

> > Jesse, where's this patch?
> >   https://patchwork.kernel.org/patch/230361/
> > I certainly hope it's scheduled for merge soon!
> > 
> > Meanwhile I've removed the other patch from my i2c-next tree, it will
> > be back only when I'm certain it applied fine.
> 
> OK, thanks

-- 
Jean Delvare
