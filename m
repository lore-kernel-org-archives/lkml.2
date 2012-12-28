Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab2L1LDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 06:03:14 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:25734 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752604Ab2L1LDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 06:03:12 -0500
Message-ID: <50DD7C5E.4080007@gaisler.com>
Date: Fri, 28 Dec 2012 12:02:54 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: software@gaisler.com, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        spi-devel-general@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/6] of: Return -ENXIO from of_parse_phandle_with_args
 for too large index and return errors from of_gpio_named_count
References: <1356610247-11491-1-git-send-email-andreas@gaisler.com> <1356610247-11491-3-git-send-email-andreas@gaisler.com>
In-Reply-To: <1356610247-11491-3-git-send-email-andreas@gaisler.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-27 13:10, Andreas Larsson wrote:
> This lets of_gpio_named_count return an errno on errors by being able to
> distinguish between reaching the end of the phandle list and getting some other
> error from of_parse_phandle_with_args.
>
> Return error from of_spi_register_master when there is an "cs-gpios" list for
> which gp_gpio_named_count fails.
>
> Adjust drivers/hwmon/gpio-fan.c to cope with error return.
>
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

The callers of of_gpio_count of course also needs to handle errno 
returns. I'll take care of that in V2 of the patch-set. But I'll wait 
for more comments on the patch set before sending V2 unless someone insists.

Cheers,
Andreas

