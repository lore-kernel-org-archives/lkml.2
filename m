Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab2LKJRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:17:52 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42707 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab2LKJRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:17:50 -0500
MIME-Version: 1.0
In-Reply-To: <1355129761-8088-8-git-send-email-lee.jones@linaro.org>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
	<1355129761-8088-8-git-send-email-lee.jones@linaro.org>
Date: Tue, 11 Dec 2012 10:17:49 +0100
Message-ID: <CACRpkdaDoLnyn4DHoEnha7zxxYA7v7nyte1CeeRyp87O6EE3xw@mail.gmail.com>
Subject: Re: [PATCH 07/12] ARM: ux500: Specify the ux5x0 MMCI regulator's
 on/off GPIO as high-enable
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 9:55 AM, Lee Jones <lee.jones@linaro.org> wrote:

> If not specified, the GPIO control bit is inverted by default i.e.
> low-enable and high-disable. This is not the case with the MMCI
> regulator, hence it will turn on during a disable and off when
> regulator_enable() is invoked.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
