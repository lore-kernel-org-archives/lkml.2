Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab2GXW6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 18:58:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:17711 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077Ab2GXW6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 18:58:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="185394612"
Date: Wed, 25 Jul 2012 00:57:49 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] mfd: wm8994: Flag the interrupt block as requiring
 runtime PM be enabled
Message-ID: <20120724225749.GF11304@sortiz-mobl>
References: <1343140966-18641-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1343140966-18641-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343140966-18641-2-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Jul 24, 2012 at 03:42:45PM +0100, Mark Brown wrote:
> It's only required in a few circumstances but better to be safe.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> Seems most sensible to merge via regmap?
Yep, definitely.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
