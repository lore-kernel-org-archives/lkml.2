Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab0HDH51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:57:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36551 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755619Ab0HDH5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:57:14 -0400
Date: Wed, 4 Aug 2010 08:57:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] wm8350-core: fix wrong kfree in error path
Message-ID: <20100804075712.GC22446@rakim.wolfsonmicro.main>
References: <1280886861.31990.5.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280886861.31990.5.camel@mola>
X-Cookie: Colorless green ideas sleep furiously.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 09:54:21AM +0800, Axel Lin wrote:
> This patch includes below fixes:
> 1. fix wm8350_create_cache error path
>    make sure wm8350->reg_cache is freed in error path.
> 2. fix wm8350_device_init error path
>    no need to kfree(wm8350->reg_cache) in the case of goto out.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Please remember to always submit separate patches for separate issues,
mixing things together makes review harder and means that if there's a
problem with one part of what you've done the entire patch gets held up.
