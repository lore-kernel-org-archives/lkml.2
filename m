Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab2DNFKZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 01:10:25 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11249 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab2DNFKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 01:10:23 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6679"; a="181677670"
Message-ID: <4F8906BD.1010601@codeaurora.org>
Date: Fri, 13 Apr 2012 22:10:21 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2] pinctrl: implement devm_pinctrl_get()/put()
References: <1334335720-3309-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1334335720-3309-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/13/2012 9:48 AM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>
> These functions allow the driver core to automatically clean up any
> allocations made by drivers, thus leading to simplified drivers.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> v2:
> * Updated documentation to describe and recommend using devm_* functions.
> * Added devm_pinctrl_get_select() and devm_pinctrl_get_select_default() to
>   consumer.h

Please also document it in Documentation/driver-model/devres.txt

> ---
>  Documentation/pinctrl.txt        |   48 +++++++++++++++++++-------------
>  drivers/pinctrl/core.c           |   56 ++++++++++++++++++++++++++++++++++++++
>  include/linux/pinctrl/consumer.h |   44 +++++++++++++++++++++++++++++
>  3 files changed, 129 insertions(+), 19 deletions(-)
>
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

