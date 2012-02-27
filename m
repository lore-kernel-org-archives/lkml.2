Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab2B0NsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 08:48:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:36444 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab2B0NsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 08:48:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="129845137"
Date: Mon, 27 Feb 2012 14:55:48 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V3] ux500 : decouple/recouple gic from the PRCMU
Message-ID: <20120227135548.GL27687@sortiz-mobl>
References: <1329737426-12855-1-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329737426-12855-1-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Mon, Feb 20, 2012 at 12:30:26PM +0100, Daniel Lezcano wrote:
> This patch allows to decouple and recouple the gic from the PRCMU.
> This is needed to put the A9 core in retention mode with the cpuidle
> driver.
> 
> It is based on top of the "DB8500 PRCMU update" patchset.
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
