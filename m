Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab2G0XJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 19:09:33 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58551 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab2G0XJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 19:09:31 -0400
MIME-Version: 1.0
In-Reply-To: <1342817939-7118-1-git-send-email-seanpaul@chromium.org>
References: <1342817939-7118-1-git-send-email-seanpaul@chromium.org>
Date: Sat, 28 Jul 2012 01:09:30 +0200
Message-ID: <CACRpkdZupvxyadxi8GppP6W2Pe5-eOcdjYYAcS28euUk8vx9iQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: samsung: Fix off-by-one bug in gpio addresses
From: Linus Walleij <linus.walleij@linaro.org>
To: Sean Paul <seanpaul@chromium.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangsu Park <sangsu4u.park@samsung.com>
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

Samsung people, please comment on this patch.

Yours,
Linus Walleij
