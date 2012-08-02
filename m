Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab2HBQPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:15:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44645 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751591Ab2HBQPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:15:48 -0400
Date: Thu, 2 Aug 2012 17:15:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] mfd: add MAX8907 core driver
Message-ID: <20120802161544.GE4537@opensource.wolfsonmicro.com>
References: <1343854085-29663-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343854085-29663-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 02:48:05PM -0600, Stephen Warren wrote:
> From: Gyungoh Yoo <jack.yoo@maxim-ic.com>
> 
> The MAX8907 is an I2C-based power-management IC containing voltage
> regulators, a reset controller, a real-time clock, and a touch-screen
> controller.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
