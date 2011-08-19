Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab1HSOTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:19:05 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44061 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab1HSOQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:16:42 -0400
MIME-Version: 1.0
In-Reply-To: <1313758358-27536-3-git-send-email-per.forlin@stericsson.com>
References: <1313758358-27536-1-git-send-email-per.forlin@stericsson.com>
	<1313758358-27536-2-git-send-email-per.forlin@stericsson.com>
	<1313758358-27536-3-git-send-email-per.forlin@stericsson.com>
Date: Fri, 19 Aug 2011 16:16:42 +0200
Message-ID: <CAKnu2Mq9N0JyrBnfJ2GupgEcKUfsGUkxZvRcBq9d2s07xUZyDA@mail.gmail.com>
Subject: Re: [PATCH v9 2/3] mmc: core: add random fault injection
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Per Forlin <per.forlin@stericsson.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, Akinobu Mita <akinobu.mita@gmail.com>,
        Chris Ball <cjb@laptop.org>, linux-doc@vger.kernel.org,
        Per Forlin <per.forlin@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/19 Per Forlin <per.forlin@stericsson.com>:

> From: Per Forlin <per.forlin@linaro.org>
>
> This adds support to inject data errors after a completed host transfer.
> The mmc core will return error even though the host transfer is successful.
> This simple fault injection proved to be very useful to test the
> non-blocking error handling in the mmc_blk_issue_rw_rq().
> Random faults can also test how the host driver handles pre_req()
> and post_req() in case of errors.
>
> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> Acked-by: Akinobu Mita <akinobu.mita@gmail.com>

OK!

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
For the MMC portions in 2/3.

Linus Walleij
