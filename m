Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab1GDRqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:46:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42027 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757927Ab1GDRqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:46:12 -0400
Date: Mon, 4 Jul 2011 10:46:00 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: [PATCH 6/6] ASoC: twl6040: No need to convert the PLL ID
Message-ID: <20110704174556.GI28726@opensource.wolfsonmicro.com>
References: <1309773958-14608-1-git-send-email-peter.ujfalusi@ti.com>
 <1309773958-14608-7-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309773958-14608-7-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 01:05:58PM +0300, Peter Ujfalusi wrote:
> Since the PLL handling has been simplified, and
> rebased on 0, there is no longer need for converting
> the PLL ID.

These are all

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

though I do generally prefer to have the IDs based off 1 as this means
that we catch people just shoving 0 in as an ID when it's not
appropriate.
