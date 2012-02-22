Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab2BVRn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 12:43:29 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39301 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab2BVRn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 12:43:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.11.129 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329720360-23227-19-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-19-git-send-email-swarren@nvidia.com>
Date: Wed, 22 Feb 2012 18:43:27 +0100
Message-ID: <CACRpkdaeCHtR3Co2d7VDWuAvhWqXSyEQ8gsNda2mKvqq-hFLzw@mail.gmail.com>
Subject: Re: [PATCH 18/20] pinctrl: Fix pinconf_groups_show() to emit newline
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 7:45 AM, Stephen Warren <swarren@nvidia.com> wrote:

> pinconf_groups_show() wrote all debug information on one line. Fix it to
> match pinconf_pins_show() and be legible.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Thanks, applied.
Linus Walleij
