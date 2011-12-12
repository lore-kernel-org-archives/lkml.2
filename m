Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab1LLPKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:10:43 -0500
Received: from mga14.intel.com ([143.182.124.37]:61404 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116Ab1LLPKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:10:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="84794456"
Date: Mon, 12 Dec 2011 16:15:47 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Correct revision display for WM1811 revision D
Message-ID: <20111212151547.GK13952@sortiz-mobl>
References: <1322671954-29177-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322671954-29177-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Nov 30, 2011 at 04:52:34PM +0000, Mark Brown wrote:
> As WM1811 revision C was transparent to software the revision IDs for
> subsequent revisions are one less than they would normally be. Correct
> for this in log messages.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> I can fold this and other updates into the big regmap changes I posted
> the other day if that's helpful?
It seems you have quite many wm8994 patches on your mfd/wm8994 branch. It
would probably make sense for you to carry them through the regmap changes. If
that's fine with you, feel free to add my Acked-by to them.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
