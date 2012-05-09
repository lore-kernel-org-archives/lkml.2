Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761197Ab2EIUpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:45:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45596 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720Ab2EIUpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:45:43 -0400
Message-ID: <4FAAD774.6010401@wwwdotorg.org>
Date: Wed, 09 May 2012 14:45:40 -0600
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
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 07/12] pinctrl: add sleep state definition
References: <1336470310-23709-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1336470310-23709-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 03:45 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> There is an IDLE definition in the pinctrl framework, but for
> ux500 SLEEP is more apropriate.
> 
> I've added some comments on the semantics of the common states
> so as to avoid misunderstandings.

> +/**
> + * @PINCTRL_STATE_DEFAULT: the state the pinctrl handle shall be put
> + *	on as default, usually this means the pins are up and ready to

"into" would be more typical than "on".
