Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab2HQWB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 18:01:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33495 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752988Ab2HQWBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 18:01:21 -0400
Date: Fri, 17 Aug 2012 23:01:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH] regulator: max8907: Fix n_voltages for MAX8907B SD1
Message-ID: <20120817220113.GF18871@opensource.wolfsonmicro.com>
References: <1345091162.14780.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345091162.14780.0.camel@phoenix>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 12:26:02PM +0800, Axel Lin wrote:
> For linear voltage mapping, the n_voltages is (max - min) / step + 1

Applied, thanks.
