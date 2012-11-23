Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab2KWHoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:44:14 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60464 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932907Ab2KWHoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:44:12 -0500
MIME-Version: 1.0
In-Reply-To: <1353409479-3304-1-git-send-email-sachin.kamat@linaro.org>
References: <1353409479-3304-1-git-send-email-sachin.kamat@linaro.org>
Date: Fri, 23 Nov 2012 08:44:11 +0100
Message-ID: <CACRpkdatVyDcTQnJ_qeZwckxJeApZBgw=_ivz98DJhNWjYFheA@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: pinctrl-single: Fix error check condition
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>,
        ext Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 12:04 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> *map should be tested for NULL instead of map.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Thanks, patch applied.

As we are late in the kernel cycle and I haven't seen reports about
regressions on this, it will wait for kernel v3.8.

Yours,
Linus Walleij
