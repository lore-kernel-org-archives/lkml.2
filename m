Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab2LATzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 14:55:16 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65150 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab2LATzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 14:55:15 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkda6=UPW+Xy9ztkAtFvCMySt4iR8YabYNNTdnZBpVc98rQ@mail.gmail.com>
References: <912d88b8906ce87cf5459cf3d5798e03bfce34c7.1353649737.git.viresh.kumar@linaro.org>
	<20121123103400.GO17471@gmail.com>
	<CAKohponW-Wd+Vrnj8mbdFMmJvwQgPq1jFCZRipBFoEhTknStHQ@mail.gmail.com>
	<20121123121413.GB22268@gmail.com>
	<20121123123048.GM5384@localhost.localdomain>
	<20121126112823.GI12782@gmail.com>
	<CACRpkda6=UPW+Xy9ztkAtFvCMySt4iR8YabYNNTdnZBpVc98rQ@mail.gmail.com>
Date: Sat, 1 Dec 2012 20:55:13 +0100
Message-ID: <CACRpkdZ03EuT4yGd_5utdTjGiokYubbPgTQuZwdcT+5oranrEg@mail.gmail.com>
Subject: Re: [PATCH] gpio: stmpe: Add DT support for stmpe gpio
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 1, 2012 at 8:34 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

> The crucial question is: can the STMPE controllers be
> used for GPIO, PWM, keypad and touchscreen at the
> *same time* or are they nailed to *one* usecase during
> electronics design?

Looking closer at the datasheet it seems to mux pins on individual per-pin
basis, so it is indeed pin-controller-like.

Was this driver submitted today, I would probably request that the
pinctrl + GPIO properties be properly exposed in the pinctrl
subsystem instead.

Yours,
Linus Walleij
