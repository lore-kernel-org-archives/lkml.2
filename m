Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab2BUNgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 08:36:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39101 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab2BUNgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 08:36:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.43.51.135 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329720360-23227-11-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-11-git-send-email-swarren@nvidia.com>
Date: Tue, 21 Feb 2012 14:36:52 +0100
Message-ID: <CACRpkdbR54cF27hU1WvGOGVZjj_S7hr014+FFD=jQEAf_QahwQ@mail.gmail.com>
Subject: Re: [PATCH 10/20] pinctrl: Assume map table entries can't have a NULL
 ctrl_dev_name field
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

> These are already disallowed. Clean up some code that doesn't assume this.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Thanks, applied!

Yours,
Linus Walleij
