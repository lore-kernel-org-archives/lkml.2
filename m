Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab1I0H0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 03:26:18 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58285 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1I0H0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 03:26:17 -0400
Date: Tue, 27 Sep 2011 08:25:18 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jon Medhurst <tixy@yxit.co.uk>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Message-ID: <20110927072517.GB11359@flint.arm.linux.org.uk>
References: <20110927112524.fd0b8f1fe69bc63855ead2d7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110927112524.fd0b8f1fe69bc63855ead2d7@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 11:25:24AM +1000, Stephen Rothwell wrote:
> Hi Arnd,
> 
> [I have a feeling that I may have reported this previously]
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mm/dma-mapping.c between commit e73fc88e19d7 ("ARM: 7059/1:
> LPAE: Use PMD_(SHIFT|SIZE|MASK) instead of PGDIR_*") from the arm tree
> and commit 99d1717dd7fe ("ARM: Add init_consistent_dma_size()") from the
> arm-soc tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.

This has happened because I've dropped a large chunk of my tree from the
for-next branch due to some horrible conflicts and some bad workflow
practice in a git tree I recently merged (so this merge which I'd
normally do has been exposed.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
