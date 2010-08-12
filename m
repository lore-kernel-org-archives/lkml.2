Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734Ab0HLKdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 06:33:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40164 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753671Ab0HLKdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 06:33:37 -0400
Date: Thu, 12 Aug 2010 11:33:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] regulator: max8998 - fix memory allocation size for
 max8998->rdev
Message-ID: <20100812103335.GA13299@rakim.wolfsonmicro.main>
References: <1281576779.25972.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281576779.25972.1.camel@mola>
X-Cookie: My mind is a potato field ...
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 09:32:59AM +0800, Axel Lin wrote:
> We only use max8998->rdev[0] .. max8998->rdev[pdata->num_regulators-1],
> max8998->rdev[pdata->num_regulators] is not used.
> Thus fix the memory allocation size.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
