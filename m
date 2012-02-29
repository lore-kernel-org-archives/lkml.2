Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab2B2QqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 11:46:10 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42800 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab2B2QqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 11:46:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.203.98 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1330460852-23486-1-git-send-email-swarren@nvidia.com>
References: <1330460852-23486-1-git-send-email-swarren@nvidia.com>
Date: Wed, 29 Feb 2012 17:46:07 +0100
Message-ID: <CACRpkdbtH7edRVc=BmCncabMzQ=OB8eQAYju3Aoh-zSnFGQ6sA@mail.gmail.com>
Subject: Re: [PATCH V2 0/6] pinctrl: API rework, pinconfig in mapping table, ...
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

On Tue, Feb 28, 2012 at 9:27 PM, Stephen Warren <swarren@nvidia.com> wrote:

> This is the current set of patches I have outstanding for pinctrl.

Thanks, now the problem is that I think this is based on top of
the other two patches, which happen to break U300 so I cannot
test it :-(

It'd be great if you could resolve the hogging issue in the other
patch set and put them as patch 1 & 2 of this patch set
so I have the whole picture and can proceed from there.

Yours,
Linus Walleij
