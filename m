Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3AFWZl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 17:25:41 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:45455 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab3AFWZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 17:25:40 -0500
Date: Sun, 6 Jan 2013 14:22:09 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] lp8788-charger: fix a parent device in _probe()
Message-ID: <20130106222209.GH26928@lizard.sbx05280.losalca.wayport.net>
References: <A874F61F95741C4A9BA573A70FE3998F69E10FE8@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E10FE8@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 06:30:16AM +0000, Kim, Milo wrote:
>  The lp8788-charger is a platform driver of lp8788-mfd.
>  The platform device is allocated when mfd_add_devices() is called
>  in lp8788-mfd.
>  On the other hand, 'lp->dev' is the i2c client device.
> 
>  Therefore, this 'platform_device' is a proper parent device in case of
>  resource managed mem alloc and device kernel message.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---

Both applied, thank you.
