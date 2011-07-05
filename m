Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab1GER7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:59:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53944 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751247Ab1GER7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:59:24 -0400
Date: Tue, 5 Jul 2011 10:59:20 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v2 3/5] ASoC: twl6040: Do not use wrapper for irq request
Message-ID: <20110705175919.GA6238@opensource.wolfsonmicro.com>
References: <1309873775-17927-1-git-send-email-peter.ujfalusi@ti.com>
 <1309873775-17927-4-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309873775-17927-4-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 04:49:33PM +0300, Peter Ujfalusi wrote:
> The twl6040_request_irq/free_irq inline functions are going
> to be removed, so replace them with direct calls.
> The irq number is provided by the core driver via resource.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
