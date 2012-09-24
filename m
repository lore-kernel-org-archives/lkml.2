Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2IXUOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:14:05 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57137 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653Ab2IXUOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:14:03 -0400
MIME-Version: 1.0
In-Reply-To: <1348474306-25155-1-git-send-email-lee.jones@linaro.org>
References: <1348474306-25155-1-git-send-email-lee.jones@linaro.org>
Date: Mon, 24 Sep 2012 22:14:02 +0200
Message-ID: <CACRpkdbmDtsb7cxWLeuBKyz0RYDX6uQjnm0uHd_ndY+NKdnHhw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mfd: Provide the PRCMU with its own IRQ domain
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 10:11 AM, Lee Jones <lee.jones@linaro.org> wrote:

> The PRCMU has its own USB, Thermal, GPIO, Modem, HSI and RTC drivers,
> amongst other things. This patch allows those subordinate devices to
> use it as an interrupt controller as and when they are DT enabled.
>
> CC: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This is good stuff.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Sam, please pick this up, IRQdomains are a pathway to many
good things.

Yours,
Linus Walleij
