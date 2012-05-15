Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab2EOHoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 03:44:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43044 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131Ab2EOHoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 03:44:03 -0400
MIME-Version: 1.0
In-Reply-To: <1336993600-30065-1-git-send-email-b29396@freescale.com>
References: <1336993600-30065-1-git-send-email-b29396@freescale.com>
Date: Tue, 15 May 2012 09:44:01 +0200
Message-ID: <CACRpkdZZXvN8V2jPe8BRcAJvqq+YtkRVSk_WdfKJ=fGxt72kPw@mail.gmail.com>
Subject: Re: [PATCH 1/5] pinctrl: a minor error checking improvement for pinconf
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, swarren@wwwdotorg.org,
        haojian.zhuang@marvell.com, shawn.guo@freescale.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 1:06 PM, Dong Aisheng <b29396@freescale.com> wrote:

> From: Dong Aisheng <dong.aisheng@linaro.org>
>
> Also checking invalid num_configs when validate the pinconf map.
>
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

Applied with Stephens ACK.

Thanks!
Linus Walleij
