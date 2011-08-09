Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab1HICfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 22:35:03 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8846 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab1HICfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 22:35:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 08 Aug 2011 19:34:11 -0700
Date: Mon, 8 Aug 2011 19:34:11 -0700
From: Robert Morell <rmorell@nvidia.com>
To: Dilan Lee <dilee@nvidia.com>
Cc: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arun.murthy@stericsson.com" <arun.murthy@stericsson.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        Jordan Nien <JNien@nvidia.com>, Stephen Warren <swarren@nvidia.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] video: Add a callback 'notify_after' for backlight
 control
Message-ID: <20110809023411.GO27748@morell.nvidia.com>
References: <1312856996-22452-1-git-send-email-dilee@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312856996-22452-1-git-send-email-dilee@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 07:29:56PM -0700, Dilan Lee wrote:
> From: Dilan Lee <dilee@nvidia.com>
> 
> We need a callback to do some things after pwm_enable, pwm_disable
> and pwm_config.
> 
> Signed-off-by: Dilan Lee <dilee@nvidia.com>

Reviewed-by: Robert Morell <rmorell@nvidia.com>

Thanks,
Robert
