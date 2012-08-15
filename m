Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab2HOQTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:19:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60933 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754419Ab2HOQTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:19:47 -0400
Date: Wed, 15 Aug 2012 17:19:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: rnayak@ti.com, lrg@ti.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] regulator: twl-regulator: fix up VINTANA1/VINTANA2
Message-ID: <20120815161945.GC15365@opensource.wolfsonmicro.com>
References: <1344982205-21186-1-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344982205-21186-1-git-send-email-aaro.koskinen@iki.fi>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 01:10:04AM +0300, Aaro Koskinen wrote:
> It seems commit 2098e95ce9bb039ff2e7bf836df358d18a176139 (regulator: twl:
> adapt twl-regulator driver to dt) accidentally deleted VINTANA1. Also
> the same commit defines VINTANA2 twice with TWL4030_ADJUSTABLE_LDO and
> TWL4030_FIXED_LDO. This patch changes the fixed one to be VINTANA1.

Applied, thanks.
