Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab2BUL3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 06:29:45 -0500
Received: from mga03.intel.com ([143.182.124.21]:48482 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347Ab2BUL3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 06:29:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="68601579"
Date: Tue, 21 Feb 2012 12:29:38 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        alsa-devel@alsa-project.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MFD/Input/ASoC: twl6040 kconfig fixes
Message-ID: <20120221112938.GX5387@sortiz-mobl>
References: <1329821171-3769-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329821171-3769-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tue, Feb 21, 2012 at 12:46:11PM +0200, Peter Ujfalusi wrote:
> To avoid breaking x86_64 allmodconfig build the Kconfig files need to be
> changed.
> Change the dependency graph of the twl6040 stack.
I had that one queued up as well. Patch applied, thanks for the quick reply.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
