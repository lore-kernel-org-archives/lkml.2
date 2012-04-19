Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab2DSRZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:25:39 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42354 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab2DSRZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:25:38 -0400
MIME-Version: 1.0
In-Reply-To: <DD6B9D658496A2488636C8C75B9C0CB601CD3224@EXMAIL04.scwf.nsc.com>
References: <DD6B9D658496A2488636C8C75B9C0CB601CD3224@EXMAIL04.scwf.nsc.com>
Date: Thu, 19 Apr 2012 19:25:38 +0200
Message-ID: <CACRpkdYErTX4ubo-_aOsq_W8OTTLUh+VQ8qT0Gh2humOFZ4BFQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] leds-lm3530: comment correction about the range of brightness
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

> max brightness is 127, so the range of brt_val should be from 0 to 127
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
