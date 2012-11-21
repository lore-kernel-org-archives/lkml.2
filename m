Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab2KUH5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:57:44 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52949 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2KUH5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:57:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpokYD7Cyv77p4MtmtJ+UJSfb3fjYWmjXkQV40Czbh7FOWw@mail.gmail.com>
References: <1353483465-25961-1-git-send-email-linus.walleij@stericsson.com>
	<CAKohpokYD7Cyv77p4MtmtJ+UJSfb3fjYWmjXkQV40Czbh7FOWw@mail.gmail.com>
Date: Wed, 21 Nov 2012 08:57:42 +0100
Message-ID: <CACRpkdbykZxp=vUzLzy6to3VhmnLjSXAKWOWj4f4S2u5xzipYg@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: fix bug and clarify OF use of ranges
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 8:42 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> This is what i was asking you earlier: "Doesn't gpiochip_add_pin_range
> have any users?" and you said NO and i didn't cross checked :(

Yes I forgot that I refactored the OF code to actually use this
function.... sorry.

Thanks,
Linus Walleij
