Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab1GDPaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:30:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:44838 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab1GDPaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:30:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,473,1304319600"; 
   d="scan'208";a="23261718"
Date: Mon, 4 Jul 2011 17:30:39 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Kalle Komierowski <kalle.komierowski@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd/ab8500-gpadc: refactor GPADC API, add raw access
Message-ID: <20110704153039.GM3021@sortiz-mobl>
References: <1309252083-26836-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309252083-26836-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Jun 28, 2011 at 11:08:03AM +0200, Linus Walleij wrote:
> From: Kalle Komierowski <kalle.komierowski@gmail.com>
> 
> - A bug in the use of the exported functions made the raw ADC
>   value converted to voltage entity twice.
Please separate this one from the API renaming/clarification.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
