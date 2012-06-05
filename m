Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab2FEMqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 08:46:24 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41849 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab2FEMqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 08:46:18 -0400
MIME-Version: 1.0
In-Reply-To: <1337816857-14694-4-git-send-email-thomas.abraham@linaro.org>
References: <1337816857-14694-1-git-send-email-thomas.abraham@linaro.org>
	<1337816857-14694-4-git-send-email-thomas.abraham@linaro.org>
Date: Tue, 5 Jun 2012 14:46:18 +0200
Message-ID: <CACRpkda1iiOFfjWbtJTf=R7qqHkzPbA3oTsWSiC08W_zctaexQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] gpio: exynos4: skip gpiolib registration if pinctrl
 driver is used
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, kyungmin.park@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 1:47 AM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:

> Pinctrl driver, when enabled, registers all the gpio pins and hence the
> registration of gpio pins by this driver can be skipped.
>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I guess it's already applied... sorry for taking so long time
to respond.

Yours,
Linus Walleij
