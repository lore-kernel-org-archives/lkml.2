Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab2KTWhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 17:37:32 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33088 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab2KTWhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 17:37:31 -0500
MIME-Version: 1.0
In-Reply-To: <1352985288-29518-1-git-send-email-lee.jones@linaro.org>
References: <1352985288-29518-1-git-send-email-lee.jones@linaro.org>
Date: Tue, 20 Nov 2012 23:37:29 +0100
Message-ID: <CACRpkdY4Ej9YZMbTLUD80bL8MnM-+TCU=LJ3Vsdskh7DLc1cgw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: ux500: Disable the MMCI gpio-regulator by default
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 2:14 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Not all supported boards will require a MMCI gpio-regulator,
> therefore it's a good idea to only enable the node when and if
> it is required. Let's disable it by default.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Sorry for the delay.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
