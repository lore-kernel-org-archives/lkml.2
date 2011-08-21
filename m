Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab1HUXHz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 19:07:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:50042 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598Ab1HUXHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 19:07:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,260,1312182000"; 
   d="scan'208";a="43630853"
Date: Mon, 22 Aug 2011 01:09:52 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: u.kleine-koenig@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mfd:fix section mismatch warning in ab3550-core
Message-ID: <20110821230952.GB4607@sortiz-mobl>
References: <20110803083255.GJ9250@pengutronix.de>
 <1312432351-15729-1-git-send-email-gaowanlong@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1312432351-15729-1-git-send-email-gaowanlong@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gao,

On Thu, Aug 04, 2011 at 12:32:31PM +0800, Wanlong Gao wrote:
> This patch fixes:
> WARNING: drivers/mfd/built-in.o(.data+0x9998): Section mismatch in reference from the variable ab3550_driver to the function .init.text:ab3550_probe()
> The variable ab3550_driver references
> the function __init ab3550_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
> 
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Patch applied, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
