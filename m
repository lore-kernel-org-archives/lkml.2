Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab2HIMiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 08:38:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60779 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753177Ab2HIMip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 08:38:45 -0400
Date: Thu, 9 Aug 2012 13:38:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2 3/3] regulator: add MAX8907 driver
Message-ID: <20120809123838.GP24328@opensource.wolfsonmicro.com>
References: <1344460727-6243-1-git-send-email-swarren@wwwdotorg.org>
 <1344460727-6243-3-git-send-email-swarren@wwwdotorg.org>
 <5023AAE5.90603@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5023AAE5.90603@nvidia.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 05:49:49PM +0530, Laxman Dewangan wrote:

> There may be possibility that some of regulator node is not
> populated and that case, the idata will be NULL and hence regulator
> registration can be bypass for that regulator.

The driver should just register all the regulators the chip has, it's
useful for diagnostic purposes if nothing else.
