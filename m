Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993364Ab2KOLEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 06:04:15 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:62976 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993226Ab2KOLEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 06:04:13 -0500
MIME-Version: 1.0
In-Reply-To: <1352768407.19229.1.camel@phoenix>
References: <1352768407.19229.1.camel@phoenix>
Date: Thu, 15 Nov 2012 12:04:12 +0100
Message-ID: <CACRpkdbXTa=b4Aja9FByzfu4c+bQcB0Ae0rKf033gi4WsEyS+A@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: imx: Fix the logic checking if not able to find
 pin reg map
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Dong Aisheng <dong.aisheng@linaro.org>,
        Devendra Naga <devendra.aaru@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 2:00 AM, Axel Lin <axel.lin@ingics.com> wrote:

> Current code sets "pin_reg = &info->pin_regs[i];" in each loop iteration,
> so in the case of no-match, pin_reg is not NULL.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Thanks, applied with Dong's ACK.

Yours,
Linus Walleij
