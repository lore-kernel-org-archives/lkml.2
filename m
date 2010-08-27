Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab0H0Jac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:30:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35934 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753405Ab0H0Jaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:30:30 -0400
Date: Fri, 27 Aug 2010 10:30:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] regulator: set max8998->dev to &pdev->dev.
Message-ID: <20100827093028.GG24381@opensource.wolfsonmicro.com>
References: <1282898254.1971.4.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282898254.1971.4.camel@mola>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 04:37:34PM +0800, Axel Lin wrote:
> max8998->dev is NULL in current implementation, set it to &pdev->dev.
> 
> regulator_register() still return success if max8998->dev is NULL,
> but rdev->dev.parent will be set to NULL which is incorrect.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
