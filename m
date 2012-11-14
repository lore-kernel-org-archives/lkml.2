Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab2KNJGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:06:06 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45512 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab2KNJGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:06:01 -0500
MIME-Version: 1.0
In-Reply-To: <1352882265.12579.2.camel@phoenix>
References: <1352882265.12579.2.camel@phoenix>
Date: Wed, 14 Nov 2012 14:36:00 +0530
Message-ID: <CAKohpom1xTdScGtFNX9n6c3EbXvGXYUDmDHwsKDt6gMoTgZCKw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: plgpio: Call clk_disable_unprepare only if
 clk_prepare_enable is called
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 November 2012 14:07, Axel Lin <axel.lin@ingics.com> wrote:
> This driver allows clk_get() failure, and still work without it.
> This patch adds !IS_ERR(plgpio->clk) checking in plgpio_request() error path
> so we only call clk_disable_unprepare() if clk_prepare_enable() is called.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
