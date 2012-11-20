Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab2KTWiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 17:38:10 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:54162 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab2KTWiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 17:38:08 -0500
MIME-Version: 1.0
In-Reply-To: <1352985288-29518-2-git-send-email-lee.jones@linaro.org>
References: <1352985288-29518-1-git-send-email-lee.jones@linaro.org>
	<1352985288-29518-2-git-send-email-lee.jones@linaro.org>
Date: Tue, 20 Nov 2012 23:38:06 +0100
Message-ID: <CACRpkdZ+1dViNVXwLsNZG+iwgH0DkypuCmLJKZE0zsPcCXM42A@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: ux500: Move board specific GPIO info out to
 subordinate DTS files
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 2:14 PM, Lee Jones <lee.jones@linaro.org> wrote:

> GPIO numbers for the newly created gpio-regulator will differ from
> board to board. Therefore it's not sensible to leave this information
> in the top level DTSI file. Let's move them out to the DTS files
> where they can correctly vary.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
