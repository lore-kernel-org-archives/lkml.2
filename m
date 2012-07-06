Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897Ab2GFHDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:03:40 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:61175 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab2GFHDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:03:38 -0400
MIME-Version: 1.0
In-Reply-To: <1341493572-29735-2-git-send-email-lee.jones@linaro.org>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
	<1341493572-29735-2-git-send-email-lee.jones@linaro.org>
Date: Fri, 6 Jul 2012 09:03:37 +0200
Message-ID: <CACRpkdYsLUQqPrYKX3AGuwkhfJO6kk=s2iSSvhwY42HgxS2dfw@mail.gmail.com>
Subject: Re: [PATCH 1/9] pinctrl: pinctrl-nomadik: Fix possible memory leak
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

> If the Nomadik Pin Control driver is continuously bound and unbound
> from the same device a number of times the kzalloc() will leak
> memory. Replacing it with devm_kzalloc() will ensure memory is
> freed automatically in the event of failure and unbinding.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

A patch like this but more all-encompassing was already sent out
by me some days ago:
http://marc.info/?l=linux-kernel&m=134139303405730&w=2

Please test that one and see if it solves your problem.

Yours,
Linus Walleij
