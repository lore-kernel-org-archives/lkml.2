Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab2KGIpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 03:45:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:29359 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab2KGIph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 03:45:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,728,1344236400"; 
   d="scan'208";a="165419812"
Date: Wed, 7 Nov 2012 10:47:51 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] gpiolib: iron out include ladder mistakes
Message-ID: <20121107084751.GU24532@intel.com>
References: <1352218863-2037-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352218863-2037-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 05:21:03PM +0100, Linus Walleij wrote:
> +static inline int
> +gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
> +		       unsigned int pin_base, unsigned int npins)
> +{
> +}

Should you return some value above? Like -ENOSYS?
