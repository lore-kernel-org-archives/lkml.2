Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab2GJJBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 05:01:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:8837 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab2GJJBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 05:01:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="190646961"
Date: Tue, 10 Jul 2012 11:13:04 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 1/1] mfd: ab8500: Clean-up the last two ab8500 related DT
 match tables
Message-ID: <20120710091304.GU15345@sortiz-mobl>
References: <1341578598-9307-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341578598-9307-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Fri, Jul 06, 2012 at 01:43:18PM +0100, Lee Jones wrote:
> A patch was recently submitted to stop all ab8500 devices from
> being registered through Device Tree. Instead, only the db8500
> will be DT:ed and the rest will continue to be registered via
> the MFD API, as they always were.
> 
> Two patches have recently been applied which enable Device Tree
> probing; one for rtc-ab8500 and the other for ponkey-ab8500.
> These two need to be removed to prevent double-probing these
> devices with Device Tree is enabled.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/input/misc/ab8500-ponkey.c |    8 --------
>  drivers/rtc/rtc-ab8500.c           |    6 ------
>  2 files changed, 14 deletions(-)
I don't know against which tree you generated those patches, but none of those
2 of_device_id arrays are in my for-next branch. So I can't apply this patch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
