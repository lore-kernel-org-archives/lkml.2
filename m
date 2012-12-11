Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2LKJTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:19:00 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53235 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab2LKJS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:18:57 -0500
MIME-Version: 1.0
In-Reply-To: <1355129761-8088-11-git-send-email-lee.jones@linaro.org>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
	<1355129761-8088-11-git-send-email-lee.jones@linaro.org>
Date: Tue, 11 Dec 2012 10:18:56 +0100
Message-ID: <CACRpkdb7s+KHYtaZLAKxLod4o=B5sRtdp091qfgqjBDgrhc9ow@mail.gmail.com>
Subject: Re: [PATCH 10/12] ARM: ux500: Setup correct settling time for the
 MMCI regulator
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 9:55 AM, Lee Jones <lee.jones@linaro.org> wrote:

> The GPIO controlled MMCI regulator used on the ux5x0 boards takes
> 100us to settle. There's already a binding to provide such
> information. Let's make use of it.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
