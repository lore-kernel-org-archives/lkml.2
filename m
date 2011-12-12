Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1LLOdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:33:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:38452 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628Ab1LLOdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:33:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="86279098"
Date: Mon, 12 Dec 2011 15:38:19 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Convert MFD drivers to use module_platform_driver
Message-ID: <20111212143819.GI13952@sortiz-mobl>
References: <1322089114-2155-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322089114-2155-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Nov 23, 2011 at 10:58:34PM +0000, Mark Brown wrote:
> Factors out some boilerplate code for drivers doing the default thing
> for platform driver registration. Drivers using platform_driver_probe
> or an initcall other than module_init can't be converted.
Thanks, applied too.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
