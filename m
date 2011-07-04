Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab1GDPfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:35:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:7025 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab1GDPe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:34:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,472,1304319600"; 
   d="scan'208";a="21404483"
Date: Mon, 4 Jul 2011 17:35:27 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd: move TPS55910 Kconfig option
Message-ID: <20110704153527.GN3021@sortiz-mobl>
References: <1309259354-32213-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309259354-32213-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Jun 28, 2011 at 01:09:14PM +0200, Linus Walleij wrote:
> Having another TPS chip at the end of the Kconfig when all it's
> relatives are grouped together in their own section seems totally
> counter-intuitive. Move it, also in the Makefile.
Thanks, patch applied (manually) to my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
