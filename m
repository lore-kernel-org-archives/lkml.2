Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906Ab2IHA5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 20:57:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46195 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758638Ab2IHA5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 20:57:22 -0400
Date: Sat, 8 Sep 2012 08:57:17 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: AnilKumar Ch <anilkumar@ti.com>
Cc: linux-kernel@vger.kernel.org, axel.lin@gmail.com, lrg@ti.com
Subject: Re: [PATCH] regulator: core: fix rdev->regmap NULL pointer
Message-ID: <20120908005716.GH4438@opensource.wolfsonmicro.com>
References: <1347030905-17722-1-git-send-email-anilkumar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347030905-17722-1-git-send-email-anilkumar@ti.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 08:45:05PM +0530, AnilKumar Ch wrote:
> Fixes rdev->regmap NULL pointer if regmap for regulator device
> is NULL. If it is NULL then get regmap for regulator device
> from its parent (MFD).
> 
> Signed-off-by: AnilKumar Ch <anilkumar@ti.com>

Applied with a rewritten commit message - this is adding a new feature,
not fixing a problem (devices can always explicitly specify a regmap,
this is just adding a new default option).  Thanks.
