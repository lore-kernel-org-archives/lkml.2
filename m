Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380Ab1EMOs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 10:48:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:3285 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349Ab1EMOs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 10:48:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,364,1301900400"; 
   d="scan'208";a="642307643"
Date: Fri, 13 May 2011 16:48:08 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH v2 2/4] MFD: TWL6030: fix irq definitions
Message-ID: <20110513144807.GH8970@sortiz-mobl>
References: <1305206878-18094-1-git-send-email-gg@slimlogic.co.uk>
 <1305206878-18094-3-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305206878-18094-3-git-send-email-gg@slimlogic.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Graeme

On Thu, May 12, 2011 at 02:27:56PM +0100, Graeme Gregory wrote:
> The charger fault IRQs from the twl will in future patches be handled
> by a seperate IRQ handler in the charger driver than the general charger
> IRQ. Give them different IRQ numbers now to allow the charger driver to
> be merged in the future.
Thanks, patch applied as well.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
