Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab0HDHu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:50:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33064 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752192Ab0HDHu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:50:28 -0400
Date: Wed, 4 Aug 2010 08:50:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] max8998: fix off-by-one value range checking
Message-ID: <20100804075025.GA22446@rakim.wolfsonmicro.main>
References: <1280903650.8393.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280903650.8393.1.camel@mola>
X-Cookie: Colorless green ideas sleep furiously.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 02:34:10PM +0800, Axel Lin wrote:
> In max8998_list_voltage() and max8998_set_voltage(),
> we use ldo as array index of ldo_voltage_map.
> Thus the valid range should be 0 .. ARRAY_SIZE(ldo_voltage_map)-1.

> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Axel, please do try to bear in mind my previous comments about supplying
subject lines for your commits consistent with those for the relevant
code area.  This makes your patches easier to apply.
