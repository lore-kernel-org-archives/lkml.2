Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947169Ab2LFUXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 15:23:16 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:47286 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947122Ab2LFUXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 15:23:13 -0500
MIME-Version: 1.0
In-Reply-To: <1354702655-26388-1-git-send-email-sachin.kamat@linaro.org>
References: <1354702655-26388-1-git-send-email-sachin.kamat@linaro.org>
Date: Thu, 6 Dec 2012 21:23:11 +0100
Message-ID: <CACRpkdaEdGLj4CuZa3tyCBhQBBTxtwS4c1D4aYJ6kGaiHJ0YUw@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: samsung: Fix a typo in pinctrl-samsung.h
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>, Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, thomas.abraham@linaro.org,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 5, 2012 at 11:17 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> struct samsung_pin_bank does not have a member called reg_offset.
> It should be pctl_offset instead.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Kukjin, art you taking this patch?

Yours,
Linus Walleij
