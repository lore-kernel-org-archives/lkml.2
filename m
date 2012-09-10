Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2IJIuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:50:13 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47345 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab2IJIuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:50:12 -0400
MIME-Version: 1.0
In-Reply-To: <1347016499-29354-4-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<1347016499-29354-4-git-send-email-lee.jones@linaro.org>
Date: Mon, 10 Sep 2012 01:50:10 -0700
Message-ID: <CACRpkda2dYTtXjgaoY1ujWLkx+iG6SdJkz=jPPcKU=bHkP_Y=g@mail.gmail.com>
Subject: Re: [PATCH 03/19] ARM: ux500: Pass SDI DMA information though
 AUX_DATA to MMCI
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:

> There are four SDIs on the HREF, as opposed to the original two
> enabled on Snowball. To get them working we have to pass their DMA
> information in the same was as we need with the other two.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Yeah this will all go away once we get our precious DMA DT
bindings.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
