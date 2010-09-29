Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab0I2InQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 04:43:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:43922 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205Ab0I2InP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 04:43:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,252,1283756400"; 
   d="scan'208";a="611483685"
Date: Wed, 29 Sep 2010 10:43:37 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Add WM8325 support
Message-ID: <20100929084337.GB2544@sortiz-mobl>
References: <1285690419-10854-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285690419-10854-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Sep 28, 2010 at 09:13:39AM -0700, Mark Brown wrote:
> The WM8325 is a PMIC for low power, high performance applications.  From
> a software point of view the device is identical to the WM8320, all the
> differences are at the hardware level.
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
