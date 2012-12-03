Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab2LCCsu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 21:48:50 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:46354 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab2LCCss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 21:48:48 -0500
Message-ID: <50BC1308.4050407@gmail.com>
Date: Mon, 03 Dec 2012 10:48:40 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: thierry.reding@avionic-design.de, linux@arm.linux.org.uk,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dt: tegra: cardhu: Add drm components
References: <1354254256-10212-1-git-send-email-markz@nvidia.com> <50B908F1.8000407@wwwdotorg.org>
In-Reply-To: <50B908F1.8000407@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2012 03:28 AM, Stephen Warren wrote:
> On 11/29/2012 10:44 PM, Mark Zhang wrote:
>> This patch adds the RGB & HDMI nodes in Tegra 30 cardhu's dts.
>> This makes the LVDS & HDMI working.
> 
> This still doesn't add any of the backlight/panel GPIO programming,
> which I believe is required before we enable any LCDs. We could add the
> HDMI node without that though.

Okay. So I think I may misunderstood your words several days ago, when I
submitted the v1 and v2 version for this patch.

So let's hold on this and wait for the backlight/panel working on cardhu.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
