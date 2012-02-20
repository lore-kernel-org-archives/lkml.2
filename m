Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab2BTQub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:50:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:50878 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab2BTQu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:50:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="127447798"
Date: Mon, 20 Feb 2012 17:57:39 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: jedu@slimlogic.co.uk, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, gg@slimlogic.co.uk,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2] mfd: tps65910: Add wakeup support
Message-ID: <20120220165739.GD5387@sortiz-mobl>
References: <1327304775-12202-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327304775-12202-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Mon, Jan 23, 2012 at 01:16:15PM +0530, Laxman Dewangan wrote:
> Implementing irq_set_wake() so that device should able
> to wakeup the system through different interrupt provided
> by this device like gpios, onkey, rtc etc.
Thanks, patch applied. And thanks to Mark for the review.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
