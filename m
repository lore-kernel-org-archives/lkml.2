Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab2JQHYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 03:24:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:26765 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab2JQHYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 03:24:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,599,1344236400"; 
   d="scan'208";a="157122352"
Date: Wed, 17 Oct 2012 10:26:23 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 6/7] gpio/langwell: find the irq domain mapping
Message-ID: <20121017072623.GL3453@intel.com>
References: <1350415403-3590-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350415403-3590-1-git-send-email-linus.walleij@linaro.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 09:23:23PM +0200, Linus Walleij wrote:
> Switch from creating the IRQ domain mapping to finding it. In this
> case we know very well that the driver has created the apropriate
> mapping, we just need to locate it, no need to create any
> on-the-fly mappings.

I may be missing something but where in the driver we create the mappings
then? I couldn't find any place where it is done.
