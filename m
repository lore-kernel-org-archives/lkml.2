Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab2AXVsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 16:48:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43025 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab2AXVsK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 16:48:10 -0500
MIME-Version: 1.0
In-Reply-To: <1327009368-23624-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1327009368-23624-1-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Tue, 24 Jan 2012 22:48:10 +0100
Message-ID: <CACRpkdYzYop11o9eZmzQwtXBFYETgeSJP7LhmT69P_qrBGxDbQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: unbreak error messages
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/19 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:

> It's better to not line break error messages to allow easier grepping
> for them even when the line gets >80 chars. Additionally some minor
> reformating is done.
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks, applied it.

Linus Walleij
