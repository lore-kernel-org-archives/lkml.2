Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab2HEJ7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 05:59:55 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46871 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab2HEJ7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 05:59:54 -0400
MIME-Version: 1.0
In-Reply-To: <1342817939-7118-1-git-send-email-seanpaul@chromium.org>
References: <1342817939-7118-1-git-send-email-seanpaul@chromium.org>
Date: Sun, 5 Aug 2012 11:59:53 +0200
Message-ID: <CACRpkdaBTfQ965H+zR_tQmGhBdPz-g=uW259cj4CsGCxq7RCvQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: samsung: Fix off-by-one bug in gpio addresses
From: Linus Walleij <linus.walleij@linaro.org>
To: Sean Paul <seanpaul@chromium.org>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, olofj@chromium.org,
        dianders@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 10:58 PM, Sean Paul <seanpaul@chromium.org> wrote:

> Move gpc4 to the end of the automatically processed gpio controllers so
> we don't taint the automatic offset calculation.
>
> This bug caused all controllers coming after gpc4 to map to the
> incorrect address. The result is <&gpd1 0 0 0 0> would actually map to
> GPIO 0 in gpd0.
>
> Signed-off-by: Sean Paul <seanpaul@chromium.org>

Patch applied with some Acks and Reviewed-by's.

Thanks,
Linus Walleij
