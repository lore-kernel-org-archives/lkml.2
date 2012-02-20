Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2BTVto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:49:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51737 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab2BTVtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:49:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.160.131 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329720360-23227-10-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-10-git-send-email-swarren@nvidia.com>
Date: Mon, 20 Feb 2012 22:49:43 +0100
Message-ID: <CACRpkday+qZ5VfGW3XDagSc4avVNSo3K_fpsFiwb-g3Prmi9zw@mail.gmail.com>
Subject: Re: [PATCH 09/20] pinctrl: Disallow map table entries with NULL
 dev_name field
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

> Hog entries are mapping table entries with .ctrl_dev_name == .dev_name.
> All other mapping table entries need .dev_name set so that they will
> match some pinctrl_get() call. All extant PIN_MAP*() macros set
> .dev_name.
>
> So, there is no reason to allow mapping table entries without .dev_name
> set. Update the code and documentation to disallow this.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

OK
Acked-by: Linus Walleij <linus.walleij@linaro.org>

I would have applied it if it wasn't that I had some questions
on earlier patches that I didn't apply so it conflicts.

Yours,
Linus Walleij
