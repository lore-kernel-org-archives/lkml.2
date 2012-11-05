Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab2KELpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 06:45:43 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36952 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab2KELpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 06:45:42 -0500
MIME-Version: 1.0
In-Reply-To: <1352043042.11324.0.camel@phoenix>
References: <1352043042.11324.0.camel@phoenix>
Date: Mon, 5 Nov 2012 12:45:41 +0100
Message-ID: <CACRpkdZ57C-NJsRnHF9Td1L4dNoymGdk47vkjefBnsH=rHk2Fw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: nomadik: Add terminating entry for
 platform_device_id table
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 4, 2012 at 4:30 PM, Axel Lin <axel.lin@ingics.com> wrote:

> The platform_device_id table is supposed to be zero-terminated.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Thanks Axel, patch applied.

Yours,
Linus Walleij
