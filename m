Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab1KNAPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 19:15:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:7129 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab1KNAPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 19:15:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,504,1315206000"; 
   d="scan'208";a="89982631"
Date: Mon, 14 Nov 2011 01:20:04 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: Convert wm8994 to devm_kzalloc()
Message-ID: <20111114002004.GH22218@sortiz-mobl>
References: <1319546861-7620-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1319546861-7620-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319546861-7620-2-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Oct 25, 2011 at 02:47:41PM +0200, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8994-core.c |   16 +++++-----------
>  1 files changed, 5 insertions(+), 11 deletions(-)
Applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
