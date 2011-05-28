Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab1E1Gia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 02:38:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:44557 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab1E1Gi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 02:38:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,285,1304319600"; 
   d="scan'208";a="10253915"
Date: Sat, 28 May 2011 08:38:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] mfd: Use mfd cell platform_data for db8500-prcmu cells
 platform bits
Message-ID: <20110528063750.GA3058@sortiz-mobl>
References: <1306489783-16227-1-git-send-email-mattias.wallin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306489783-16227-1-git-send-email-mattias.wallin@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mattias,

On Fri, May 27, 2011 at 11:49:43AM +0200, Mattias Wallin wrote:
> With the addition of a device platform mfd_cell pointer, MFD drivers
> can go back to passing platform data back to their sub drivers.
> This allows for an mfd_cell->mfd_data removal and thus keep the
> sub drivers MFD agnostic. This is mostly needed for non MFD aware
> sub drivers.
Thanks a lot, patch applied now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
