Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab2KOReS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 12:34:18 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46445 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798Ab2KOReQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 12:34:16 -0500
MIME-Version: 1.0
In-Reply-To: <1352995295.10636.1.camel@phoenix>
References: <1352995295.10636.1.camel@phoenix>
Date: Thu, 15 Nov 2012 18:34:15 +0100
Message-ID: <CACRpkdapymohVKdpovB6V_noH+9E2daV+SbYUK2zPhro=6HUEw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: nomadik: Staticize non-exported symbols
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        Patrice Chotard <patrice.chotard@stericsson.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 5:01 PM, Axel Lin <axel.lin@ingics.com> wrote:

> They are not referenced outside of this file, make them static.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied with Lee's ACK, thanks!

Yours,
Linus Walleij
