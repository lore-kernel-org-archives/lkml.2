Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab1HICNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 22:13:47 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18659 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab1HICNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 22:13:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 08 Aug 2011 19:12:59 -0700
Date: Mon, 8 Aug 2011 19:12:58 -0700
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
Message-ID: <20110809021258.GM27748@morell.nvidia.com>
References: <1312855525-21464-1-git-send-email-dilee@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312855525-21464-1-git-send-email-dilee@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 07:05:25PM -0700, Dilan Lee wrote:
[...]
> For example, GPIO backlight_en has to be risen after pwm has been enabled
> to meet panel power on sequence defined in panel specification.

I still think this information is irrelevant/nonsensical here, and
should be omitted entirely..

[...]

>  	unsigned int		lth_brightness;
>  	int			(*notify)(struct device *,
> -					  int brightness);
> +					int brightness);

Please don't change the line above; unlike the one you added after, it
was already lined up properly with its argument list.

Otherwise,
Reviewed-by: Robert Morell <rmorell@nvidia.com>
