Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab1AYHvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 02:51:15 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33529 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab1AYHvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 02:51:14 -0500
Date: Tue, 25 Jan 2011 16:51:04 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Heiko Schocher <hs@denx.de>
Cc: linuxppc-dev@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@ozlabs.org, Ben Dooks <ben@simtec.co.uk>,
        Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 2/4 v4] video, sm501: add edid and commandline support
Message-ID: <20110125075104.GJ11673@linux-sh.org>
References: <1291451028-22532-1-git-send-email-hs@denx.de> <1295863047-11131-1-git-send-email-hs@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295863047-11131-1-git-send-email-hs@denx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 10:57:27AM +0100, Heiko Schocher wrote:
> @@ -1884,7 +1935,6 @@ static int __devinit sm501fb_probe(struct platform_device *pdev)
>  
>  	if (info->pdata == NULL) {
>  		dev_info(dev, "using default configuration data\n");
> -		info->pdata = &sm501fb_def_pdata;
>  	}
>  
>  	/* probe for the presence of each panel */

I assume this is accidental? I don't see how you're compensating for this
in any of the other patches at least, as it's orthogonal from the default
mode settings.
