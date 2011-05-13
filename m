Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371Ab1EMOrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 10:47:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:6515 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349Ab1EMOre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 10:47:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,364,1301900400"; 
   d="scan'208";a="1829851"
Date: Fri, 13 May 2011 16:47:31 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH v2 1/4] MFD: TWL6025: add phoenix lite support to
 twl6030
Message-ID: <20110513144730.GG8970@sortiz-mobl>
References: <1305206878-18094-1-git-send-email-gg@slimlogic.co.uk>
 <1305206878-18094-2-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305206878-18094-2-git-send-email-gg@slimlogic.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Graeme,

On Thu, May 12, 2011 at 02:27:55PM +0100, Graeme Gregory wrote:
> Phoenix Lite is based on the twl6030 family of PMICs. It has mostly the
> same feature set of twl6030 but with small changes. The codec block has
> also been removed. It also has a new charger block and new features in
> its ADC block. VUSB handling also differs.
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
