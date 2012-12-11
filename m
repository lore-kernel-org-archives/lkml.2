Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab2LKJTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:19:30 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53235 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab2LKJT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:19:27 -0500
MIME-Version: 1.0
In-Reply-To: <1355129761-8088-13-git-send-email-lee.jones@linaro.org>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
	<1355129761-8088-13-git-send-email-lee.jones@linaro.org>
Date: Tue, 11 Dec 2012 10:19:26 +0100
Message-ID: <CACRpkdazRYxuWustdd9TEYbu=ZipBO8ZsLnTDGTosWCPsPEgiw@mail.gmail.com>
Subject: Re: [PATCH 12/12] ARM: ux500: Remove traces of the ios_handler from
 platform code
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 9:56 AM, Lee Jones <lee.jones@linaro.org> wrote:

> Now MMCI on/off functionality is using the regulator framework
> from the MMCI driver, there is no need to keep the ios_handler
> laying around, duplicating functionality. So we're removing it.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>
(Provided the rest is merged first.)

Yours,
Linus Walleij
