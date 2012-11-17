Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab2KQBW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 20:22:57 -0500
Received: from mail-gh0-f174.google.com ([209.85.160.174]:36594 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab2KQBWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 20:22:55 -0500
MIME-Version: 1.0
X-Originating-IP: [218.173.173.171]
In-Reply-To: <50A686A1.6000304@gmail.com>
References: <1352641495.3113.1.camel@phoenix>
	<50A0C3C8.2020501@gmail.com>
	<CAFRkauABcnqJSqewueY4rzVbm7uAqkZKitkR9ZmYjF0LhR26-Q@mail.gmail.com>
	<50A686A1.6000304@gmail.com>
Date: Sat, 17 Nov 2012 09:22:54 +0800
Message-ID: <CAFRkauDg-HqYnBTatx-f6Rd3xZkD5CYE3Zc_-WdfwQX60F_HTg@mail.gmail.com>
Subject: Re: [PATCH RFT 1/2] pinctrl: dove: Fix dove_audio1_ctrl_set when
 BIT(0|1|2|3) of config is clear
From: Axel Lin <axel.lin@ingics.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> pinctrl for Dove will not be enabled before DT clock support for Dove,
> which will hopefully make it into 3.8. If you agree, I will test and push it
> with the related patches for enabling pinctrl.
Ok. Thanks.

Axel
