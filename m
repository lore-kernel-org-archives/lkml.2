Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934221Ab2LIPhT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 10:37:19 -0500
Received: from mga03.intel.com ([143.182.124.21]:22249 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934208Ab2LIPhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 10:37:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,246,1355126400"; 
   d="scan'208";a="178574467"
Date: Sun, 9 Dec 2012 16:37:12 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, lee.jones@linaro.org,
        linus.walleij@linaro.org, Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH V7] mfd: stmpe: Update DT support for stmpe driver
Message-ID: <20121209153712.GF26699@sortiz-mobl>
References: <91449dfa3338a603f443765b0948aa2e1b98a600.1354892244.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91449dfa3338a603f443765b0948aa2e1b98a600.1354892244.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Fri, Dec 07, 2012 at 08:29:37PM +0530, Viresh Kumar wrote:
> From: Vipul Kumar Samar <vipulkumar.samar@st.com>
> 
> This patch extends existing DT support for stmpe devices. This updates:
> - missing header files in stmpe.c
> - stmpe_of_probe() with pwm, rotator and new bindings.
> - Bindings are updated in binding document.
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> V6->V7:
> - Minor grammer correction in stmpe.txt
> - Removed comment over pdata->id = -1
Very good, patch applied to my for-next branch now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
