Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab2IJHKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 03:10:44 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40112 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2IJHKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 03:10:41 -0400
MIME-Version: 1.0
In-Reply-To: <1346835718-21325-3-git-send-email-peter.ujfalusi@ti.com>
References: <1346835718-21325-1-git-send-email-peter.ujfalusi@ti.com>
	<1346835718-21325-3-git-send-email-peter.ujfalusi@ti.com>
Date: Mon, 10 Sep 2012 09:10:39 +0200
Message-ID: <CACRpkdbiCV4sKy2JAb6Yu5EuOVbfhq46yu5FRy7MXNT3QR6gaw@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: pinctrl-single: Add pinctrl-single,bits type
 of mux
From: Linus Walleij <linus.walleij@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 11:01 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:

> With pinctrl-single,bits it is possible to update just part of the register
> within the pinctrl-single,function-mask area.
> This is useful when one register configures mmore than one pin's mux.
>
> pinctrl-single,bits takes three parameters:
> <reg offset, value, sub-mask>
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Do we have a conclusion on this patch 2/2?

I'm holding it back until Tony explicitly ACKs it for now.

Yours,
Linus Walleij
