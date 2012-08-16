Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab2HPHwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 03:52:03 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:38536 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805Ab2HPHwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 03:52:00 -0400
Message-ID: <502CA69A.2000500@ti.com>
Date: Thu, 16 Aug 2012 13:21:54 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] regulator: twl-regulator: fix up VINTANA1/VINTANA2
References: <1344982205-21186-1-git-send-email-aaro.koskinen@iki.fi>
In-Reply-To: <1344982205-21186-1-git-send-email-aaro.koskinen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 August 2012 03:40 AM, Aaro Koskinen wrote:
> It seems commit 2098e95ce9bb039ff2e7bf836df358d18a176139 (regulator: twl:
> adapt twl-regulator driver to dt) accidentally deleted VINTANA1. Also
> the same commit defines VINTANA2 twice with TWL4030_ADJUSTABLE_LDO and
> TWL4030_FIXED_LDO. This patch changes the fixed one to be VINTANA1.

Thanks for the fix, the commit does seem to have mixed up things.

Acked-by: Rajendra Nayak <rnayak@ti.com>
