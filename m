Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab2EIUxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:53:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54839 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab2EIUxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:53:52 -0400
Message-ID: <4FAAD95D.9010108@wwwdotorg.org>
Date: Wed, 09 May 2012 14:53:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 12/12] ARM: ux500: switch MSP to using pinctrl for pins
References: <1336470347-23886-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1336470347-23886-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 03:45 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> The MSP platform data callbacks use the old custom callbacks to
> set the state of the pins, switch over to using pinctrl.

Aside from the comments I've already made, I guess you can consider the
whole series:

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

I'm not at all familiar with this HW, and didn't look at every detail,
but at least I see no particular reason not to ack it.
