Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab2HFLR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 07:17:59 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43462 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab2HFLR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 07:17:57 -0400
MIME-Version: 1.0
In-Reply-To: <1344250002-6011-7-git-send-email-lee.jones@linaro.org>
References: <1344250002-6011-1-git-send-email-lee.jones@linaro.org>
	<1344250002-6011-7-git-send-email-lee.jones@linaro.org>
Date: Mon, 6 Aug 2012 13:17:56 +0200
Message-ID: <CACRpkdZmZtQJ_tqp8=cC2NbRvNosN8rDwfwDxocw=a=WtH0sZg@mail.gmail.com>
Subject: Re: [PATCH 6/6] Input: ab8500-ponkey: Make the distinction between DT
 and non-DT boots
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 12:46 PM, Lee Jones <lee.jones@linaro.org> wrote:

> If we're booting with Device Tree enabled, we want the IRQ numbers to
> be taken and translated from the Device Tree binary. If not, they
> should be taken from the resource allocation defined in the AB8500 MFD
> core driver.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Aha that's the missing patch.
Tested-by: Linus Walleij <linus.walleij@linaro.org>

This one should be split off from the patch series and sent as a separate
fix to Dmitry as it badly needs to go into the -rc series through the input
tree.

Can't see what it is doing as part of this series, it has no relation to the
other patches.

Dmitry, you can replace my revert with this patch as soon as Lee send
it to linux-input.

Yours,
Linus Walleij
