Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab2AQJC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 04:02:58 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:52414 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752437Ab2AQJCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 04:02:53 -0500
MIME-Version: 1.0
In-Reply-To: <1326789637.7383.1.camel@phoenix>
References: <1326789637.7383.1.camel@phoenix>
Date: Tue, 17 Jan 2012 10:02:53 +0100
Message-ID: <CACRpkdYhi5QZdJiZSJAWK=RGvYdzcQ9d2japgnmvUnP5oGxAAg@mail.gmail.com>
Subject: Re: [PATCH] gpio: Add missing spin_lock_init in gpio-pch driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 9:40 AM, Axel Lin <axel.lin@gmail.com> wrote:

> This bug was introduced by commit d568a681
> "gpio-pch: add spinlock in suspend/resume processing"
> which adds a spinlock to struct pch_gpio but never init the spinlock.
>
> Reported-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
