Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab2IJLMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 07:12:31 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36638 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab2IJLMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 07:12:24 -0400
MIME-Version: 1.0
In-Reply-To: <1347016499-29354-11-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<1347016499-29354-11-git-send-email-lee.jones@linaro.org>
Date: Mon, 10 Sep 2012 04:12:23 -0700
Message-ID: <CACRpkdY_gyWRO20ZOfTmG=tzE_B3ObWZG_4f8gHS6vyiGZSh6Q@mail.gmail.com>
Subject: Re: [PATCH 10/19] ARM: ux500: Remove redundant #gpio-cell properties
 from HREF and Snowball DT
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

> These properties have no place here as the populated nodes are
> not related to GPIO Controllers.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Squash this into the previous patch adding them...
I think Arnd already noted.

Yours,
Linus Walleij
