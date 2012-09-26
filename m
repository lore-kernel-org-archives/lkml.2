Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2IZLfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 07:35:25 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54920 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab2IZLfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 07:35:24 -0400
MIME-Version: 1.0
In-Reply-To: <1348585812-32073-1-git-send-email-lee.jones@linaro.org>
References: <1348585812-32073-1-git-send-email-lee.jones@linaro.org>
Date: Wed, 26 Sep 2012 13:35:23 +0200
Message-ID: <CACRpkdYJZO8m1xHYS2DHYk3sbeoG4izTyLk6rP96AqX9hM=z8Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: Fix initialisation order for UIBs
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 5:10 PM, Lee Jones <lee.jones@linaro.org> wrote:

> An earlier change prevented User Interface Boards (UIBs) from being
> initialised on boards which did not support them. This change had
> the undesired effect of reordering the UIB initialisation calls with
> I2C registration. Here we ensure UIBs are only setup after all
> required infrastructure is already in place.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
