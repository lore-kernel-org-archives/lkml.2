Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2GFHLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:11:35 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44968 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab2GFHLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:11:33 -0400
MIME-Version: 1.0
In-Reply-To: <1341493572-29735-7-git-send-email-lee.jones@linaro.org>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
	<1341493572-29735-7-git-send-email-lee.jones@linaro.org>
Date: Fri, 6 Jul 2012 09:11:32 +0200
Message-ID: <CACRpkdanWJyK1OoXUCRiypoprJwefJ9zEkEVTS5f7V-sRR_z=w@mail.gmail.com>
Subject: Re: [PATCH 6/9] ARM: ux500: Remove PMU platform registration when
 booting with DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 3:06 PM, Lee Jones <lee.jones@linaro.org> wrote:

> PMU registration is successfully completed by Device Tree now, so
> there is no longer a requirement to register it from platform code.
> This patch removes platform registration during a DT boot.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
