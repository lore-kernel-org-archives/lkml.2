Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab2APM2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 07:28:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58067 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754421Ab2APM2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 07:28:14 -0500
Date: Sun, 15 Jan 2012 12:20:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: AnilKumar Ch <anilkumar@ti.com>
Cc: sameo@linux.intel.com, lrg@ti.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, nsekhar@ti.com
Subject: Re: [PATCH V4 2/2] regulator: tps65217: Add tps65217 regulator driver
Message-ID: <20120115122009.GF3040@opensource.wolfsonmicro.com>
References: <1326278509-31310-1-git-send-email-anilkumar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326278509-31310-1-git-send-email-anilkumar@ti.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 04:11:49PM +0530, AnilKumar Ch wrote:

> +	rdev = regulator_register(&regulators[pdev->id], &pdev->dev,
> +				  pdev->dev.platform_data, tps);

Oh, actually - this needs redoing against -next, regulator_register now
takes an additional of_node argument.  If there's no device tree support
it can be null.
