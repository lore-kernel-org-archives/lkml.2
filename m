Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab0HDHze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:55:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36546 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750699Ab0HDHzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:55:33 -0400
Date: Wed, 4 Aug 2010 08:55:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] wm8994-core: fix wm8994_device_init() return value
Message-ID: <20100804075530.GB22446@rakim.wolfsonmicro.main>
References: <1280886287.31990.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280886287.31990.1.camel@mola>
X-Cookie: Colorless green ideas sleep furiously.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 09:44:47AM +0800, Axel Lin wrote:
> wm8994_device_init() will return 0 in the case of kzalloc fail
> in current implementation.
> This patch fixes the return value.

> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
