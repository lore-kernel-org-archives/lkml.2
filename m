Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab2K1PsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:48:17 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:58030 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab2K1PsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:48:16 -0500
MIME-Version: 1.0
In-Reply-To: <1353673123-32340-1-git-send-email-tushar.behera@linaro.org>
References: <1353673123-32340-1-git-send-email-tushar.behera@linaro.org>
Date: Wed, 28 Nov 2012 16:48:14 +0100
Message-ID: <CACRpkdar_H=siMOrzddgw94uA76bZPCgZPpWVwVE28L47CXjOg@mail.gmail.com>
Subject: Re: [PATCH] mfd: ab8500-core: Fix invalid free of devm_ allocated data
From: Linus Walleij <linus.walleij@linaro.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sameo@linux.intel.com, srinidhi.kasagar@stericsson.com,
        patches@linaro.org, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 1:18 PM, Tushar Behera <tushar.behera@linaro.org> wrote:

> The objects allocated by devm_* APIs are managed by devres and are
> freed when the device is detached. Hence there is no need to remove
> them explicitly in remove function.
>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>

Looks good to me.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
