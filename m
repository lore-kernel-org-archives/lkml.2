Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab2BXFdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 00:33:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57167 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab2BXFdS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 00:33:18 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.179.8 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329945961-29547-1-git-send-email-swarren@nvidia.com>
References: <1329945961-29547-1-git-send-email-swarren@nvidia.com>
Date: Fri, 24 Feb 2012 06:33:17 +0100
Message-ID: <CACRpkdZPNGTG8HvWk4cf+DdJvEpr6o38L6mdvt4v2mEV0mvCzw@mail.gmail.com>
Subject: Re: [PATCH V2 0/4] pinctrl: Rebased/extracted patches
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 10:25 PM, Stephen Warren <swarren@nvidia.com> wrote:

> The first 3 patches were previously ack'd but weren't applied due to earlier
> patches in the original series not having been applied. These rebased versions
> can be applied directly on top of the pinctrl for-next branch.
>
> The last patch is the conceptually ack'd portion of the larger locking rework
> patch, extracted on its own for commit.
>
> Stephen Warren (4):
>  pinctrl: Disallow map table entries with NULL dev_name field
>  pinctrl: Use dev_*() instead of pr_*(), add some msgs, minor cleanups
>  pinctrl: Allocate sizeof(*p) instead of sizeof(struct foo)
>  pinctrl: Remove pin and hogs locks from struct pinctrl_dev

Thanks a ton Stephen, all patches applied and pushed to for-next.

Yours,
Linus Walleij
