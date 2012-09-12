Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab2ILVVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 17:21:31 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36283 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab2ILVV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 17:21:29 -0400
MIME-Version: 1.0
In-Reply-To: <1347016499-29354-19-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<1347016499-29354-19-git-send-email-lee.jones@linaro.org>
Date: Wed, 12 Sep 2012 23:21:28 +0200
Message-ID: <CACRpkdZKrvU3s+f+nVXOPkcFUWnq9KaFtPNCcs+fP8POGQ1Lvg@mail.gmail.com>
Subject: Re: [PATCH 18/19] gpio: Provide the tc3589x GPIO expander driver with
 an IRQ domain
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:

> In preparation for Device Tree enablement all IRQ controllers
> should control their own IRQ domain. This patch provides just
> that for the tc3589x GPIO expander.
>
> CC: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I've applied this to my GPIO tree, I couldn't resist. It's just such
a nice patch nicing up the code and I wanted it tested so it can
go into the next merge window.

If you need to send patches to the ARM SoC tree, just state
the devel branch from my tree as dependency.

Yours,
Linus Walleij
