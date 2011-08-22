Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab1HVNnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:43:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:38979 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab1HVNnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:43:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,263,1312182000"; 
   d="scan'208";a="42709561"
Date: Mon, 22 Aug 2011 15:45:08 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Allow WM8994 LDO enable pulls to be disabled
Message-ID: <20110822134508.GQ4607@sortiz-mobl>
References: <1313111900-9166-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313111900-9166-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Aug 12, 2011 at 10:18:20AM +0900, Mark Brown wrote:
> In systems where the LDO enables are always driven (for example, being
> connected to an always on supply rail or a GPIO which is driven by the
> CPU even in suspend) then we can disable the pull downs on the LDO for
> a small power savings.
I applied this one, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
