Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab2IPXpG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 19:45:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:33928 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047Ab2IPXpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 19:45:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,432,1344236400"; 
   d="scan'208";a="222802666"
Date: Mon, 17 Sep 2012 01:45:01 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 16/19] mfd: Provide the tc3589x with its own IRQ domain
Message-ID: <20120916234501.GP3647@sortiz-mobl>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
 <1347016499-29354-17-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347016499-29354-17-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Fri, Sep 07, 2012 at 12:14:56PM +0100, Lee Jones wrote:
> In preparation for Device Tree enablement all IRQ controllers
> should control their own IRQ domain. This patch provides just
> that.
> 
> CC: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/tc3589x.c       |   73 ++++++++++++++++++++++++++++---------------
>  include/linux/mfd/tc3589x.h |    1 +
>  2 files changed, 48 insertions(+), 26 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
