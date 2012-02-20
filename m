Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab2BTQh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:37:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:46034 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab2BTQh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:37:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="112447182"
Date: Mon, 20 Feb 2012 17:45:06 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1] mfd: tps65910: Initialize irq platform data properly
Message-ID: <20120220164506.GZ5387@sortiz-mobl>
References: <1326898156-11293-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326898156-11293-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Wed, Jan 18, 2012 at 08:19:16PM +0530, Laxman Dewangan wrote:
> irq_base of the tps65910 irq platform data should be
> initialized with the board provided irq_base data.
Thanks, patch applied to both my for-next and for-linus branches.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
