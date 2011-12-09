Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab1LIJQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 04:16:30 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57872 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab1LIJQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 04:16:26 -0500
MIME-Version: 1.0
In-Reply-To: <1323399055-31850-1-git-send-email-shawn.guo@linaro.org>
References: <20111209020948.GA28216@b20223-02.ap.freescale.net>
	<1323399055-31850-1-git-send-email-shawn.guo@linaro.org>
Date: Fri, 9 Dec 2011 07:16:24 -0200
Message-ID: <CAOMZO5DemwevSw0=B4+wrDSR4tfmnPDAkY7cHwKiuHnq9pu5pg@mail.gmail.com>
Subject: Re: [PATCH] arm/imx: fix cpufreq build error
From: Fabio Estevam <festevam@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Richard Zhao <richard.zhao@freescale.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 9, 2011 at 12:50 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> This patch adds missing linux/module.h to fix the build error seen
> on imx cpuidle driver.

It would be nice to add which was the commit that introduced this build error.

Regards,

Fabio Estevam
