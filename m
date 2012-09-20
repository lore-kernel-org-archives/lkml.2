Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab2ITNNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:13:30 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37397 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab2ITNN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:13:29 -0400
MIME-Version: 1.0
In-Reply-To: <1348130883-11329-1-git-send-email-stigge@antcom.de>
References: <1348130883-11329-1-git-send-email-stigge@antcom.de>
Date: Thu, 20 Sep 2012 10:13:28 -0300
Message-ID: <CAAAP30GdYj-Kcb_qu4QEv-eqy5=kp0HS4V2-f4QSVhyo07xrBg@mail.gmail.com>
Subject: Re: [PATCH] gpio-lpc32xx: Fix value handling of gpio_direction_output()
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 5:48 AM, Roland Stigge <stigge@antcom.de> wrote:
> For GPIOs of gpio-lpc32xx, gpio_direction_output() ignores the value argument
> (initial value of output). This patch fixes this by setting the level
> accordingly.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Nice catch.
