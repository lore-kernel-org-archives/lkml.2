Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab1FURfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 13:35:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46185 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754220Ab1FURfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 13:35:07 -0400
Date: Tue, 21 Jun 2011 18:35:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: [PATCH v6 15/18] ASoC: twl6040: Remove pll and headset mode
 dependency
Message-ID: <20110621173505.GC26592@opensource.wolfsonmicro.com>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
 <1308663556-29120-16-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308663556-29120-16-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 04:39:13PM +0300, Peter Ujfalusi wrote:
> From: Misael Lopez Cruz <misael.lopez@ti.com>
> 
> Remove dependency between pll (hppll, lppll) and headset power
> mode (low-power, high-performance), as headset power mode can
> be used with any pll.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but you should note that the code has been modified since Misael's
original version.
