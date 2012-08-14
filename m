Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab2HNIip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:38:45 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61071 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab2HNIim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:38:42 -0400
MIME-Version: 1.0
In-Reply-To: <1344527268-5964-2-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<1344527268-5964-2-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 10:38:41 +0200
Message-ID: <CACRpkdb1CeoLa-+FAKRFwbXVbup_KFM_WTMrKUEGXtXqogZhWg@mail.gmail.com>
Subject: Re: [PATCH 01/22] ARM: ux500: Fix merge error, no matching driver
 name for 'snd_soc_u8500'
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        broonie@opensource.wolfsonmicro.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Ola LILJA2 <ola.o.lilja@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:47 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The platform attempts to register platform device 'snd_soc_u8500'
> which doesn't actually exist. Here we change the reference to the
> correct one 'snd_soc_mop500'.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied to fixes. I will send this upstream for the -rc:s.

Yours,
Linus Walleij
