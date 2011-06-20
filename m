Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab1FTNuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 09:50:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:30150 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab1FTNud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 09:50:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,394,1304319600"; 
   d="scan'208";a="15569972"
Date: Mon, 20 Jun 2011 15:50:40 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Robert Rosengren <robert.rosengren@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/3] mfd: ab8500-core MFD devices marked as initdata
Message-ID: <20110620135040.GM22420@sortiz-mobl>
References: <1307656653-6258-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307656653-6258-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, Jun 09, 2011 at 11:57:33PM +0200, Linus Walleij wrote:
> From: Robert Rosengren <robert.rosengren@stericsson.com>
> 
> Internal MFD device structs are marked as __devinitdata since the kernel
> will allocate memory for the same when calling mfd_add_devices.
Thanks a lot, all 3 patches applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
