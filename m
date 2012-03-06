Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab2CFR2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 12:28:31 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60081 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab2CFR2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 12:28:30 -0500
Message-ID: <4F56493A.1090700@wwwdotorg.org>
Date: Tue, 06 Mar 2012 10:28:26 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH] pinctrl: include machine header to core.h
References: <1331038557-1398-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1331038557-1398-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 05:55 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> struct pinctrl_setting contains an enum pinctrl_map_type
> field, so we need to include machine.h. Also fix kerneldoc
> to indicate that the pinctrl_setting is about both muxing
> and other config.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
