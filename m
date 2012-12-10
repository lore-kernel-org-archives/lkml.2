Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab2LJJWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:22:18 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60432 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab2LJJWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:22:14 -0500
MIME-Version: 1.0
In-Reply-To: <1354881208-9930-1-git-send-email-sachin.kamat@linaro.org>
References: <1354881208-9930-1-git-send-email-sachin.kamat@linaro.org>
Date: Mon, 10 Dec 2012 10:22:13 +0100
Message-ID: <CACRpkdZXdMWtBZ0RR+AMLRxS_qxP_osOSdnMc_4GMjDwaRP9MQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] power/ab8500_charger: Use devm_regulator_get API
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, cbou@mail.ru,
        anton.vorontsov@linaro.org, patches@linaro.org,
        Arun R Murthy <arun.murthy@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 7, 2012 at 12:53 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> devm_regulator_get() is device managed and makes error handling
> and code cleanup simpler.
>
> Cc: Arun R Murthy <arun.murthy@stericsson.com>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Looks good to me!

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
