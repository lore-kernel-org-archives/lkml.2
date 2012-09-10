Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab2IJNIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 09:08:20 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47264 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757803Ab2IJNIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:08:13 -0400
MIME-Version: 1.0
In-Reply-To: <1347016499-29354-18-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<1347016499-29354-18-git-send-email-lee.jones@linaro.org>
Date: Mon, 10 Sep 2012 06:08:12 -0700
Message-ID: <CACRpkdY43ms2CqTjbFo1KP6r2H23Zj1ivTd4fSYtjMO9sDWqwg@mail.gmail.com>
Subject: Re: [PATCH 17/19] mfd: Enable the tc3589x for Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Here we provide a means to probe and extract vital information
> from Device Tree when booting with it enabled. Without this
> patch sub-devices wouldn't be able to reference the tc3589x
> from Device Tree.
>
> CC: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Looks like a good start (I guess all subdevices need to be
augmented too...) FWIW:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
