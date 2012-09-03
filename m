Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab2ICLRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 07:17:03 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58965 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab2ICLRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 07:17:01 -0400
MIME-Version: 1.0
In-Reply-To: <1345720529-32315-5-git-send-email-thomas.abraham@linaro.org>
References: <1345720529-32315-1-git-send-email-thomas.abraham@linaro.org>
	<1345720529-32315-5-git-send-email-thomas.abraham@linaro.org>
Date: Mon, 3 Sep 2012 13:17:00 +0200
Message-ID: <CACRpkda5MkXbePf8B8rY8w3rjowzE8MqtWH_cehOqUoKTTY=9Q@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] ARM: EXYNOS: skip wakeup interrupt setup if
 pinctrl driver is used
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, kgene.kim@samsung.com,
        dong.aisheng@linaro.org, swarren@wwwdotorg.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 1:15 PM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:

> Pinctrl driver includes support for configuring the external wakeup
> interrupts. On exynos platforms that use pinctrl driver, the setup
> of wakeup interrupts in the exynos platform code can be skipped.
>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
