Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab2GEOiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:38:06 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:58208 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab2GEOiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:38:05 -0400
MIME-Version: 1.0
In-Reply-To: <1341498754-30445-1-git-send-email-lee.jones@linaro.org>
References: <1341498754-30445-1-git-send-email-lee.jones@linaro.org>
Date: Thu, 5 Jul 2012 16:38:04 +0200
Message-ID: <CACRpkdZrTea7tLSJ95x43hGfw_qunBHxPgrhJpRrH3cJC43weA@mail.gmail.com>
Subject: Re: [PATCH] of: address: Don't fail a lookup just because a node has
 no reg property
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 4:32 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Sometimes it doesn't make any sense for a node to have an address.
> In this case device lookup will always be unsuccessful because we
> currently assume every node will have a reg property. This patch
> changes the semantics so that the resource address and the lookup
> address will only be compared if one exists.
>
> Things like AUXDATA() rely on of_dev_lookup to return the lookup
> entry of a particular device in order to do things like apply
> platform_data to a device. However, this is currently broken for
> nodes which do not have a reg property, meaning that platform_data
> can not be passed in those cases.
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I sure see the problem!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
