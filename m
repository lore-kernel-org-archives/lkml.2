Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab1HVKDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 06:03:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:62806 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708Ab1HVKDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 06:03:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,262,1312182000"; 
   d="scan'208";a="42626884"
Date: Mon, 22 Aug 2011 12:05:36 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: linux-kernel@vger.kernel.org, philipp.zabel@gmail.com, mad_soft@inbox.ru,
        koen@dominion.thruhere.net
Subject: Re: [PATCH] mfd: asic3: Fix SD card resume after suspend
Message-ID: <20110822100536.GJ4607@sortiz-mobl>
References: <E1Qqp9K-0000wd-O4@outmx06.plus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Qqp9K-0000wd-O4@outmx06.plus.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Tue, Aug 09, 2011 at 04:27:24PM +0000, Paul Parsons wrote:
> The mfd/asic3 driver did not define the suspend/resume handlers for the mmc cell
> driver. Consequently the mmc driver did not resume properly after returning from
> suspend, making sd cards unusable and preventing suspend from being entered a
> second time. This patch adds the suspend/resume handlers, fixing the problem.
> 
> Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
Thanks, all 4 patches applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
