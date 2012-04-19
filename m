Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab2DSR0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:26:51 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52460 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab2DSR0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:26:50 -0400
MIME-Version: 1.0
In-Reply-To: <DD6B9D658496A2488636C8C75B9C0CB601CD3226@EXMAIL04.scwf.nsc.com>
References: <DD6B9D658496A2488636C8C75B9C0CB601CD3226@EXMAIL04.scwf.nsc.com>
Date: Thu, 19 Apr 2012 19:26:49 +0200
Message-ID: <CACRpkdZ3g4ZLpG1iRtwNx5u6O=si0MmuW14v+zwvEKPqxG-BDA@mail.gmail.com>
Subject: Re: [PATCH 2/2] leds-lm3530: simplify als configuration on initialization
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 8:40 AM, Kim, Milo <Milo.Kim@ti.com> wrote:

> For better code readability, ALS code was moved to new function - lm3530_als_configure()
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
