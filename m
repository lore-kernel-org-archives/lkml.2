Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab2IDIxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 04:53:36 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36224 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab2IDIxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 04:53:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120903133333.GE31163@gmail.com>
References: <1345809612-30992-1-git-send-email-lee.jones@linaro.org>
	<20120903133333.GE31163@gmail.com>
Date: Tue, 4 Sep 2012 10:53:32 +0200
Message-ID: <CACRpkdb_aW-uxf_4GQpRWJhLqD_QujH1BOFeG4MgVHfRasGY+A@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: Provide SMSC911x fixed-regulator when not
 booting DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 3, 2012 at 3:33 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Author: Lee Jones <lee.jones@linaro.org>
> Date:   Fri Aug 24 12:40:58 2012 +0100
>
>     ARM: ux500: Provide SMSC911x fixed-regulator when not booting DT
>
>     The SMSC911x Ethernet chip requires a fixed-regulator in order to
>     function correctly. We have previously provided a means to obtain
>     this during a Device Tree boot, however nothing has been put into
>     place when booting with a non-DT kernel. This patch aims to change
>     that.
>
>     Signed-off-by: Lee Jones <lee.jones@linaro.org>

You forgot to add select REGULATOR_FIXED_VOLTAGE to
the MOP500 Kconfig entry, but I added it when applying.

Yours,
Linus Walleij
