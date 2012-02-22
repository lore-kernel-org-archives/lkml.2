Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab2BVGxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 01:53:13 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:23776
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751676Ab2BVGxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 01:53:12 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 22 Feb 2012 15:01:05 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@stericsson.com>, <B29396@freescale.com>,
        <s.hauer@pengutronix.de>, <dongas86@gmail.com>, <shawn.guo@linaro.org>,
        <thomas.abraham@linaro.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/20] pinctrl: Use dev_*() instead of pr_*(), add some
 msgs, minor cleanups
Message-ID: <20120222070104.GF11087@shlinux2.ap.freescale.net>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
 <1329720360-23227-13-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1329720360-23227-13-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 19, 2012 at 11:45:52PM -0700, Stephen Warren wrote:
> e.g. dev_err instead of pr_err prints messages in a slightly more
> standardized format.
> 
> Also, add a few more error messages to track down errors.
> 
> Also, some small cleanups of messages.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---

Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng

