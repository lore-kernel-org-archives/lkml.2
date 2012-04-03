Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab2DCV3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 17:29:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63307 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2DCV3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 17:29:35 -0400
MIME-Version: 1.0
In-Reply-To: <1333382148-14137-1-git-send-email-daniel.lezcano@linaro.org>
References: <1333382148-14137-1-git-send-email-daniel.lezcano@linaro.org>
Date: Tue, 3 Apr 2012 23:29:34 +0200
Message-ID: <CACRpkdagADj4YacxA5DqdQHKO2fkdCmwjK3pY_TAwCYU_C67GQ@mail.gmail.com>
Subject: Re: [PATCH] mfd : dbx500 : fix compilation error
From: Linus Walleij <linus.walleij@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>, sameo@linux.intel.com
Cc: srinidhi.kasagar@stericsson.com, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 2, 2012 at 5:55 PM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:

> The ux500 default config enables the db5500 and the db8500.
> The incoming cpuidle driver uses the 'prcmu_enable_wakeups'
> and the 'prcmu_set_power_state' functions but these ones
> are defined but not implemented for the db5500, leading to
> an unresolved symbol error at link time. In order to compile,
> we have to disable the db5500 support which is not acceptable
> for the default config.
>
> I noticed there are also some other functions which are
> defined but not implemented.
>
> This patch fix this by removing the functions definitions
> and move out of the config section the empty functions which
> are normally used when the DB550 config is disabled.
> Only the functions which are not implemented are concerned
> by this modification.
>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Sam, please push this to the -rc series if you can.

Yours,
Linus Walleij
