Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab2HBR4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 13:56:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33661 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755021Ab2HBR4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 13:56:51 -0400
Date: Thu, 2 Aug 2012 18:56:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] mfd: add MAX8907 core driver
Message-ID: <20120802175646.GG4537@opensource.wolfsonmicro.com>
References: <1343854085-29663-1-git-send-email-swarren@wwwdotorg.org>
 <20120802161544.GE4537@opensource.wolfsonmicro.com>
 <501AB4B9.5030805@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501AB4B9.5030805@wwwdotorg.org>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 11:11:21AM -0600, Stephen Warren wrote:

> Samuel, please don't apply this just yet though - it looks like I need
> to make some minor changes to the header file and DT binding
> documentation to add in a definition for one more regulator. I'll repost
> the amended version along with the regulator driver later.

Please carry my review forward on the next submission.
