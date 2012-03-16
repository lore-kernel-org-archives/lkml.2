Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab2CPTwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:52:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:38243 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756774Ab2CPTv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:51:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="129862459"
Date: Fri, 16 Mar 2012 20:59:54 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/3] mfd: db8500-prcmu: remove obsolete hwacc
 implementation
Message-ID: <20120316195954.GT20524@sortiz-mobl>
References: <1331837426-17761-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331837426-17761-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, Mar 15, 2012 at 07:50:26PM +0100, Linus Walleij wrote:
> From: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
> 
> This patch removes the obsolete hwacc implementation in the
> DB8500 PRCMU driver.
Nice. This one and the next 2 patches, all applied.
Thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
