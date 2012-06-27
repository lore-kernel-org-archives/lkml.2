Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab2F0Nns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:43:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:33207 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab2F0Nnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:43:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="185616457"
Subject: Re: [PATCH] dma: tegra: add clk_prepare/clk_unprepare
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
Cc: dan.j.williams@intel.com, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, ldewangan@nvidia.com
In-Reply-To: <1340605891-19076-1-git-send-email-pgaikwad@nvidia.com>
References: <1340605891-19076-1-git-send-email-pgaikwad@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jun 2012 19:04:10 +0530
Message-ID: <1340804050.1562.246.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 12:01 +0530, Prashant Gaikwad wrote:
> Use clk_prepare/clk_unprepare as required by the generic clk framework.
Applied, thanks

-- 
~Vinod

