Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab1AaAtf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 19:49:35 -0500
Received: from mga14.intel.com ([143.182.124.37]:12137 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757Ab1AaAte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 19:49:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,402,1291622400"; 
   d="scan'208";a="381912482"
Date: Mon, 31 Jan 2011 01:49:26 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Convert pcf50633 to dev_pm_ops
Message-ID: <20110131004925.GI2565@sortiz-mobl>
References: <1295560362-6693-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295560362-6693-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Jan 20, 2011 at 09:52:42PM +0000, Mark Brown wrote:
> There is a move to deprecate bus-specific PM operations and move to
> using dev_pm_ops instead in order to reduce the amount of boilerplate
> code in buses and facilitiate updates to the PM core. Do this move for
> the pcf50633 driver.
Patch applied, thanks again.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
