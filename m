Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab2GXWxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 18:53:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:52775 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828Ab2GXWxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 18:53:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="197598299"
Date: Wed, 25 Jul 2012 00:53:05 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@liniux.intel.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: arizona: Add debug trace on entering and leaving
 runtime suspend
Message-ID: <20120724225305.GD11304@sortiz-mobl>
References: <1342800552-10436-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342800552-10436-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Jul 20, 2012 at 05:09:12PM +0100, Mark Brown wrote:
> There doesn't appear to be any useful diagnostic information from the
> core.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c |    4 ++++
>  1 file changed, 4 insertions(+)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
