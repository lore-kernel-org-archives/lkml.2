Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab2LJGq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 01:46:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53493 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792Ab2LJGq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 01:46:58 -0500
Date: Mon, 10 Dec 2012 15:46:51 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org, dianders@chromium.org,
        olof@lixom.net, grant.likely@secretlab.ca, thomas.abraham@linaro.org,
        kgene.kim@samsung.com, sameo@linux.intel.com
Subject: Re: [RFC PATCH 2/3] regulator: max77686: Add support for various
 operating modes
Message-ID: <20121210064650.GJ10927@opensource.wolfsonmicro.com>
References: <1355120784-31118-1-git-send-email-a.kesavan@samsung.com>
 <1355120784-31118-2-git-send-email-a.kesavan@samsung.com>
 <1355120784-31118-3-git-send-email-a.kesavan@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355120784-31118-3-git-send-email-a.kesavan@samsung.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 11:56:23AM +0530, Abhilash Kesavan wrote:

> +		if (of_property_read_u32(rdata[i].of_node, "max77686-opmode",
> +			&rdata[i].opmode)) {
> +			dev_warn(iodev->dev, "no op_mode property property at %s\n",
> +			rmatch.name);
> +			rdata[i].opmode = regulators[i].enable_mask;
> +		}

Binding documenation is mandatory for any new OF properties, please add
this.
