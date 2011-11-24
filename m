Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab1KXKdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:33:11 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51745 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab1KXKdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:33:09 -0500
Date: Thu, 24 Nov 2011 10:32:56 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Wan ZongShun <mcuos.com@gmail.com>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] ARM: add subname parameter to mfp_set_groupg callers
Message-ID: <20111124103256.GE22232@flint.arm.linux.org.uk>
References: <1322103983.16201.7.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322103983.16201.7.camel@phoenix>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 11:06:23AM +0800, Axel Lin wrote:
> commit 798681bf "ARM: 7158/1: add new MFP implement for NUC900"
> adds subname parameter for mfp_set_groupg.
> 
> Thus add subname parameter to the callers.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> commit 798681bf is in Russell King's tree,

It's in mainline as of 20th November.

> I think this patch should route via Russell's tree.
> This patch is against linux-next 20111123.

Is there a reason why this isn't copied to linux-arm-kernel ?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
