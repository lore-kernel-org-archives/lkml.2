Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab0LNX6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 18:58:07 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50684 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab0LNX6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 18:58:06 -0500
Date: Tue, 14 Dec 2010 23:57:46 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Martin <dave.martin@linaro.org>
Subject: Re: linux-next: manual merge of the arm tree with the arm-current
	tree
Message-ID: <20101214235746.GB21913@flint.arm.linux.org.uk>
References: <20101215105435.3ce83f21.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101215105435.3ce83f21.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 10:54:35AM +1100, Stephen Rothwell wrote:
> Hi Russell,
> 
> Today's linux-next merge of the arm tree got a conflict in
> arch/arm/Kconfig between commit 6e6fc998b8c127fe06b9350a1f16e41bfe4f109d
> ("ARM: 6533/1: Thumb-2: Make CONFIG_THUMB2_KERNEL depend on !CPU_V6")
> from the arm-current tree and commit
> 4a50bfe365a977f634311504484342fbfffe855c ("ARM: Ensure experimental
> options are so marked") from the arm tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Yea, rather unfortunate.  I'll fix it up locally once arm-current is
merged into mainline.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
