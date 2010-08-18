Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab0HRNkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:40:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:25503 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833Ab0HRNkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:40:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,227,1280732400"; 
   d="scan'208";a="314003945"
Date: Wed, 18 Aug 2010 15:40:50 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Thibaut Girka <thib@sitedethib.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Smedia Glamo 3362 drivers
Message-ID: <20100818134049.GD2608@sortiz-mobl>
References: <1278508326-7109-1-git-send-email-thib@sitedethib.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278508326-7109-1-git-send-email-thib@sitedethib.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thibaut,

On Wed, Jul 07, 2010 at 03:12:02PM +0200, Thibaut Girka wrote:
> Those drivers provide MMC and display functionalities of the Smedia Glamo 3362,
> a multi-function device used in the Neo FreeRunner.
> 
> First patch is for the glamo core driver, needed for every other driver.
> The second is for MMC support.
> The third is for the GPIO interface.
> The last one is for the framebuffer driver. In the case of the FreeRunner,
> it is only useful with the glamo-gpio driver.
I finally reviewed the MFD driver. Sorry for being so lazy.
Could you please re-send the other ones with the corresponding maintainers
Cc'ed ? I can have a look at the GPIO one, but the MMC and the framebuffer
ones are out of my league.

Cheers,
Samuel.


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
