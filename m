Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab2FABhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 21:37:48 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44437 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab2FABhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 21:37:46 -0400
MIME-Version: 1.0
In-Reply-To: <1337816857-14694-3-git-send-email-thomas.abraham@linaro.org>
References: <1337816857-14694-1-git-send-email-thomas.abraham@linaro.org>
	<1337816857-14694-3-git-send-email-thomas.abraham@linaro.org>
Date: Fri, 1 Jun 2012 09:37:45 +0800
Message-ID: <CACRpkdYA1on77kDb3qvJGr9E332EiNt_piY40iLHY3rs4f57=w@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl: add exynos4210 specific driver data for
 samsung pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, kyungmin.park@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 7:47 AM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:

> Add information about the Exynos4210 pin banks, SoC specific configuration
> callbacks and driver data which is used by the Samsung pinctrl driver.
>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Overall this patch set is looking really good, just the final touches
on the main
driver needed from my point of view, would be nice to have some DT review
though.

Yours,
Linus Walleij
