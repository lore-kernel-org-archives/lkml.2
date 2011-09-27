Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab1I0PZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 11:25:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63762 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab1I0PZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 11:25:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Date: Tue, 27 Sep 2011 17:24:46 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jon Medhurst <tixy@yxit.co.uk>
References: <20110927112524.fd0b8f1fe69bc63855ead2d7@canb.auug.org.au> <20110927072517.GB11359@flint.arm.linux.org.uk>
In-Reply-To: <20110927072517.GB11359@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109271724.46371.arnd@arndb.de>
X-Provags-ID: V02:K0:5rJnEslUJGdc5O2s6AonY7Vwv/hAujpa8E6YWyn87YC
 ke9MLz5CRhigZPwURH3XbJSG9L4YkhsRTcCbLefmiX5lL7/82/
 7HD2cAeOQx6pSaevvVY+moJYrS2hTZ8nDv3xt7ZbSue1/UgpdK
 eJMsk/8kp6k6o4nT6AtDEXt3GNevFsnRlBNkh5LEgiY8H5EBI1
 6Sew1qo6A7Xf/iTdBLRcFq+VeSdk/N6WaQTKRrdA/QJ+yDRxdy
 5wk+C7JCDCSWgpZdIK5HzZ0EbEeb6wSM5ap/jEhthawwrS65Ja
 y5KPRAN0oocXjk7G/bTloe3fMlWcPIxe34PJBKwsZGpoZVQ+ij
 bVTrRUofG4/q7XQ2nZG8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 September 2011, Russell King wrote:
> On Tue, Sep 27, 2011 at 11:25:24AM +1000, Stephen Rothwell wrote:
> > Hi Arnd,
> > 
> > [I have a feeling that I may have reported this previously]
> > 
> > Today's linux-next merge of the arm-soc tree got a conflict in
> > arch/arm/mm/dma-mapping.c between commit e73fc88e19d7 ("ARM: 7059/1:
> > LPAE: Use PMD_(SHIFT|SIZE|MASK) instead of PGDIR_*") from the arm tree
> > and commit 99d1717dd7fe ("ARM: Add init_consistent_dma_size()") from the
> > arm-soc tree.
> > 
> > I fixed it up (I think - see below) and can carry the fix as necessary.

Ok, looks good.

> This has happened because I've dropped a large chunk of my tree from the
> for-next branch due to some horrible conflicts and some bad workflow
> practice in a git tree I recently merged (so this merge which I'd
> normally do has been exposed.)

Since we have a few conflicts already, I think I'll wait for your
tree to go in first and then send my pull requests with the proper
fixups. I could already pull in some branches that I know I will
have to wait for.

Do you generally send one pull request for each branch you have
in the for-next branch, or do you send a single request for something
that roughly resembles the for-next branch at the time of the merge
window?

	Arnd
