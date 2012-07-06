Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab2GFHxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:53:54 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35923 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab2GFHxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:53:53 -0400
MIME-Version: 1.0
In-Reply-To: <1341493572-29735-10-git-send-email-lee.jones@linaro.org>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
	<1341493572-29735-10-git-send-email-lee.jones@linaro.org>
Date: Fri, 6 Jul 2012 09:25:00 +0200
Message-ID: <CACRpkda_-3r1=S1mJfFYwN4f5SOMD1_A62BhqhM0T-mQEjnTeA@mail.gmail.com>
Subject: Re: [PATCH 9/9] ARM: ux500: Over-ride the DT device naming scheme for pinctrl
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Gabriel FERNANDEZ <gabriel.fernandez@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 3:06 PM, Lee Jones <lee.jones@linaro.org> wrote:

> When pin control mapping tables are written the registered device
> name is supplied for use in name-based searches within the pinctrl
> driver. In the case of the DB8500 the string "pinctrl-db8500" is
> used. However, when we register the driver with Device Tree, its
> naming convention uses something that looks more like "pinctrl.2".
>
> To work around the device naming inconsistencies between devices
> registered via platform code and the ones registered by Device
> Tree, we use AUXDATA to over-ride the Device Tree naming scheme.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

But I guess it won't work without the patch that Rob is herding.
So maybe that patch should go in with this one.

Yours,
Linus Walleij
