Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab0CXAeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 20:34:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53573 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab0CXAeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 20:34:20 -0400
Date: Wed, 24 Mar 2010 00:34:09 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: John Stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] arm: convert arm to arch_gettimeoffset()
Message-ID: <20100324003409.GB24827@flint.arm.linux.org.uk>
References: <1269385522-2525-1-git-send-email-johnstul@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269385522-2525-1-git-send-email-johnstul@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 04:05:21PM -0700, John Stultz wrote:
> Convert arm to use GENERIC_TIME via the arch_getoffset() infrastructure,
> reducing the amount of arch specific code we need to maintain.
> 
> The arm architecture is the last arch that need to be converted.

Much easier to merge, thanks.

While looking for a machine to build-test this, I noticed that the IOP/IXP
platforms have ARCH_USES_GETTIMEOFFSET - yet they select PLAT_IOP which
in turn selects GENERIC_TIME etc.

I think ARCH_IOP13XX, ARCH_IOP32X and ARCH_IOP33X shouldn't select
ARCH_USES_GETTIMEOFFSET - do you agree?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
