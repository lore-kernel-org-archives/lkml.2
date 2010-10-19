Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901Ab0JSJi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:38:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:62353 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440Ab0JSJi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:38:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,349,1283756400"; 
   d="scan'208";a="618130108"
Date: Tue, 19 Oct 2010 11:38:25 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] mfd: Factor out WM831x I2C I/O from the core driver
Message-ID: <20101019093824.GE2736@sortiz-mobl>
References: <1286556780-5610-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286556780-5610-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Oct 08, 2010 at 09:52:58AM -0700, Mark Brown wrote:
> In preparation for the addition of SPI support for the WM831x move the I2C
> specific code into a separate file with a separate Kconfig option so the
> I2C support can be excluded from the build.
> 
> Also update the 1133-EV1 PMIC module support for SMDK6410 to use the new
> symbol.
Patch applied, many thanks.

Cheers,
Samuel.
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
