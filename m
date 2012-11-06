Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab2KFIWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:22:20 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43289 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab2KFIWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:22:19 -0500
MIME-Version: 1.0
In-Reply-To: <1352122936.14769.4.camel@phoenix>
References: <1352122936.14769.4.camel@phoenix>
Date: Tue, 6 Nov 2012 09:22:17 +0100
Message-ID: <CACRpkdY4z1iib=Ekvu=JxVMvoCCqV2rSMU1_gcK-=AfYa=LOxQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: u300: Staticize non-exported symbols
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 2:42 PM, Axel Lin <axel.lin@ingics.com> wrote:

> Staticize u300_pin_config_get() and u300_pin_config_set() functions.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

OK it still builds after this, patch applied!

Thanks!
Linus Walleij
