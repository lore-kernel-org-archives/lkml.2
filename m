Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab2IKNAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:00:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:33695 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037Ab2IKNAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:00:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,404,1344236400"; 
   d="scan'208";a="201497197"
Date: Tue, 11 Sep 2012 15:00:41 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH] mfd: ab8500: Make ab8500_irq_get_virq() static
Message-ID: <20120911130041.GS3647@sortiz-mobl>
References: <1345460017-404-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345460017-404-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Mon, Aug 20, 2012 at 11:53:36AM +0100, Lee Jones wrote:
> MFD core now takes care of  HWIRQ <-> VIRQ mapping, so the helper
> ab8500_irq_get_virq() is no longer used by ab8500 subordinate devices
> to obtain a Linux wide Virtual IRQ. The AB8500 IRQ controller still
> uses it internally though, so we'll just hide it from the rest of the
> world by making it static instead.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/ab8500-core.c         |   33 ++++++++++++++++-----------------
>  include/linux/mfd/abx500/ab8500.h |    2 --
>  2 files changed, 16 insertions(+), 19 deletions(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
