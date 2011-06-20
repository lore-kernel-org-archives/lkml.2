Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab1FTN3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 09:29:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:60636 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab1FTN33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 09:29:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,394,1304319600"; 
   d="scan'208";a="15903261"
Date: Mon, 20 Jun 2011 15:29:33 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd/ab3550: Use kstrtoul_from_user
Message-ID: <20110620132933.GK22420@sortiz-mobl>
References: <1307393012-32582-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307393012-32582-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, Jun 06, 2011 at 10:43:31PM +0200, Peter Huewe wrote:
> This patch replaces the code for getting an unsigned long from a
> userspace buffer by a simple call to kstroul_from_user.
> This makes it easier to read and less error prone.
Thanks, both patches applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
