Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab2GLGIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 02:08:20 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10475 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab2GLGIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 02:08:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 11 Jul 2012 23:07:19 -0700
Message-ID: <4FFE6800.1030409@nvidia.com>
Date: Thu, 12 Jul 2012 11:30:32 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Peter Korsgaard <jacmet@sunsite.dk>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Vitaly Wool <vitalywool@gmail.com>, Colin Cross <ccross@android.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 0/7] PM / I2C: Convert platform I2C drivers to PM handling
 based on struct dev_pm_ops
References: <201207112121.11046.rjw@sisk.pl>
In-Reply-To: <201207112121.11046.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 July 2012 12:51 AM, Rafael J. Wysocki wrote:
> [7/7] i2c-tegra: Use struct dev_pm_ops for power management
>

I did not get the 7/7 on my inbox and hence responding  here.
Looked change from link
https://lkml.org/lkml/2012/7/11/467

This is same as which I sent some days ago:
https://lkml.org/lkml/2012/7/10/275

I am fine with the change:

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
