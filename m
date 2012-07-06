Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab2GFHEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:04:46 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:34978 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab2GFHEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:04:44 -0400
MIME-Version: 1.0
In-Reply-To: <1341493572-29735-3-git-send-email-lee.jones@linaro.org>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
	<1341493572-29735-3-git-send-email-lee.jones@linaro.org>
Date: Fri, 6 Jul 2012 09:04:43 +0200
Message-ID: <CACRpkdZDQB+ycvXxmVB0CkVPo6PAjiXBQFpTYVGoekz+eyOHGg@mail.gmail.com>
Subject: Re: [PATCH 2/9] pinctrl: pinctrl-nomadik: Append sleepmode property
 with vendor specific prefixes
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Gabriel FERNANDEZ <gabriel.fernandez@stericsson.com>,
        Patrice CHOTARD <patrice.chotard@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 3:06 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Any non-standard property should contain the vendor's identifier which
> should be perpended onto the property name followed by a comma. This
> aids in name-space collision prevention. This patch ensures the
> sleepmode property adheres to the rules.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

OK, Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
