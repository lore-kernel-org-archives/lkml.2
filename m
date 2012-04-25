Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab2DYSHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:07:21 -0400
Received: from nbd.name ([46.4.11.11]:38388 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871Ab2DYSHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:07:20 -0400
Message-ID: <4F983D09.7040905@openwrt.org>
Date: Wed, 25 Apr 2012 20:06:01 +0200
From: John Crispin <blogic@openwrt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] pinctrl: add error messages to pinmux_map_to_setting()
References: <1335371657-24120-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1335371657-24120-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/12 18:34, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>
> pinmux_map_to_setting() detects a number of errors, but doesn't report
> any specifics to the user, making debugging those errors hard.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> John, Linus,
>
> This is mostly just FYI in case John wants to roll this into his error
> reporting patch - it's all the changes I made to any non-Tegra files when
> debugging my DT map data.
>
>  drivers/pinctrl/pinmux.c |   38 ++++++++++++++++++++++++++++----------
>  1 files changed, 28 insertions(+), 10 deletions(-)
Hi Stephen,

I was just about to send my patch. However, I will first fold your
suggestions into it.

Thanks,
John
