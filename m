Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab1BUUFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 15:05:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:48379 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab1BUUFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 15:05:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,202,1297065600"; 
   d="scan'208";a="660002944"
Date: Mon, 21 Feb 2011 21:05:16 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Put WM8994 into reset when suspending
Message-ID: <20110221200515.GC14163@sortiz-mobl>
References: <>
 <1298313031-5132-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298313031-5132-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Feb 21, 2011 at 06:30:31PM +0000, Mark Brown wrote:
> Ensure that the chip is in the lowest power mode possible when suspended
> by performing a soft reset on it. On early silicon revisions the lowest
> power modes can't be entered without using reset so we can't achieve
> equivalent results within the individual drivers.
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
