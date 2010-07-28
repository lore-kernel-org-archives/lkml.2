Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab0G1Tud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 15:50:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50895 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab0G1Tuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 15:50:32 -0400
Date: Wed, 28 Jul 2010 20:49:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Peter Huewe <PeterHuewe@gmx.de>, Tejun Heo <tj@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] arm/mach-ixp2000: Add missing comma - fix build failure
Message-ID: <20100728194938.GA5772@n2100.arm.linux.org.uk>
References: <201007282043.13561.PeterHuewe@gmx.de> <20100728191531.GA10719@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100728191531.GA10719@shutemov.name>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 10:15:31PM +0300, Kirill A. Shutemov wrote:
> On Wed, Jul 28, 2010 at 08:43:13PM +0200, Peter Huewe wrote:
> > From: Peter Huewe <peterhuewe@gmx.de>
> > 
> > This trivial patch fixes a build failure [1] by adding a missing comma.
> 
> It has been fixed by updated patch:
> 
> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6269/1

And committed.  I want to give the MMCI changes I've committed yesterday
a run before I push the tree out though.
