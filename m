Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab2GFHLB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:11:01 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:47241 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab2GFHLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:11:00 -0400
MIME-Version: 1.0
In-Reply-To: <1341493572-29735-6-git-send-email-lee.jones@linaro.org>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
	<1341493572-29735-6-git-send-email-lee.jones@linaro.org>
Date: Fri, 6 Jul 2012 09:10:59 +0200
Message-ID: <CACRpkdbuTHN3chTVXZfLHhpOAwdRNCz-35VRQgsiCc=n-XL5Bg@mail.gmail.com>
Subject: Re: [PATCH 5/9] ARM: ux500: Remove temporary snowball_of_platform_devs
 enablement structure
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 3:06 PM, Lee Jones <lee.jones@linaro.org> wrote:

> All Device Tree enablement for Snowball's Platform  devices; LEDs, Keys,
> Ethernet and all associated AB8500 Multi-Functional Devices are now
> complete, so here we remove any trace of adding those devices when Device
> Tree is enabled.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Sweet!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
