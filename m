Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab2IDJ3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 05:29:06 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50802 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab2IDJ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 05:29:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120904090846.GA6091@gmail.com>
References: <1345809612-30992-1-git-send-email-lee.jones@linaro.org>
	<20120903133333.GE31163@gmail.com>
	<CACRpkdb_aW-uxf_4GQpRWJhLqD_QujH1BOFeG4MgVHfRasGY+A@mail.gmail.com>
	<20120904090846.GA6091@gmail.com>
Date: Tue, 4 Sep 2012 11:29:02 +0200
Message-ID: <CACRpkdb9X1ay6A1jJk==73azz0bbto0V4pBO=vOfC30_ygwZLg@mail.gmail.com>
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

On Tue, Sep 4, 2012 at 11:08 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Tue, Sep 04, 2012 at 10:53:32AM +0200, Linus Walleij wrote:
>
>> You forgot to add select REGULATOR_FIXED_VOLTAGE to
>> the MOP500 Kconfig entry, but I added it when applying.
>
> I didn't forget. I intentionally left it out because it's
> unconditionally set in the defconfig.

Since disabling that from the config breaks compile this means
that you just broke Arnds randconfig builds :-P

If something *must* be configured for the thing to compile,
so it with select.

Yours,
Linus Walleij
