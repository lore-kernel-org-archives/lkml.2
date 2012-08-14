Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab2HNLUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:20:34 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53796 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab2HNLUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:20:33 -0400
MIME-Version: 1.0
In-Reply-To: <1344527268-5964-19-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<1344527268-5964-19-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 13:20:32 +0200
Message-ID: <CACRpkdaJcfLNzZ4s4NOyBLROjNbNfP8m0EewFkwe6tTrCS-Hog@mail.gmail.com>
Subject: Re: [PATCH 18/22] ARM: ux500: Rename MSP board file to something more meaningful
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:47 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The 'msp' board file does more than just register MSP devices. It
> also registers some other components necessary to get audio working
> on ux500 based platforms; such as the PCM and Machine Drivers. For
> that reason we're changing the filename to be more encompassing -
> 'audio'.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Ideally I want Ola to confirm this but it looks OK to me.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Consider using git format-patch -m which detects renames
and makes for much more compact patches.

Yours,
Linus Walleij
