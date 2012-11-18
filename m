Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab2KRXXq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 18:23:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:34245 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab2KRXXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 18:23:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,275,1352102400"; 
   d="scan'208";a="251087527"
Date: Mon, 19 Nov 2012 00:23:42 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 RESEND 0/4] mfd: tps65910: use regmap irq framework
 for interrupt
Message-ID: <20121118232342.GA18738@sortiz-mobl>
References: <1352815439-26040-1-git-send-email-ldewangan@nvidia.com>
 <20121113195637.GQ27828@sortiz-mobl>
 <20121114012439.GF4415@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114012439.GF4415@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Nov 14, 2012 at 10:24:41AM +0900, Mark Brown wrote:
> On Tue, Nov 13, 2012 at 08:56:37PM +0100, Samuel Ortiz wrote:
> 
> > The patchset looks fine, but it should either go through Mark's tree or I
> > should merge Mark's regmap_irq_get_domain patch to my for-next branch.
> > Mark, any preference ?
> 
> I don't mind that much, there's a tag in my regmap tree you can pull in
> to integrate or I can apply things just as easily.
I merged your topic/domain branch into my for-next one and I applied Laxman
patches on top of it, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
