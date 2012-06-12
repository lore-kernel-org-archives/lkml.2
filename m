Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab2FLOcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:32:13 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56321 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab2FLOcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:32:11 -0400
MIME-Version: 1.0
In-Reply-To: <4FD6F7C6.80002@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-15-git-send-email-lee.jones@linaro.org>
	<CACRpkdbJdA8rgcXX4Xc3sMrx==5jd-Scu1Xy0UKz0ot3_bbNzw@mail.gmail.com>
	<4FD6F7C6.80002@linaro.org>
Date: Tue, 12 Jun 2012 16:32:10 +0200
Message-ID: <CACRpkdYiZkRT-XLbEBRzCBKJ+721OBVKmUF+v17seFiWxmndnw@mail.gmail.com>
Subject: Re: [PATCH 14/14] ARM: ux500: Move rtc-pl031 registration to Device
 Tree when enabled
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 10:03 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On 11/06/12 22:43, Linus Walleij wrote:

>> Oh this is a bug fix really, well it's in the device tree so nevermind.
>
> It is? How so?

That the device tree was declaring a compatible node for something
that never existed (stericsson,db8500-rtc) while the real node is
"arm,rtc-pl031", "arm,primecell".

Without this fix 3.4 will not have an PL031 RTC I guess?

Yours,
Linus Walleij
