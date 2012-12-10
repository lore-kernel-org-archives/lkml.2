Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab2LJOM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:12:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59249 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321Ab2LJOM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:12:57 -0500
Date: Mon, 10 Dec 2012 23:12:52 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org
Subject: Re: [PATCH 03/12] regulator: gpio-regulator: Fix logical error in
 for() loop
Message-ID: <20121210141251.GD6103@opensource.wolfsonmicro.com>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
 <1355129761-8088-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355129761-8088-4-git-send-email-lee.jones@linaro.org>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 08:55:52AM +0000, Lee Jones wrote:
> The cond-statement of this particular for() loop will always be
> true as long as at least one voltage-shifting GPIO is present.
> If it wasn't for the break below, we'd be stuck in a forever loop.
> This patch inserts the correct cond-statement into the statement.

Applied, thanks.
