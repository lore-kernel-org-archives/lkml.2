Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab2INNyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:54:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48601 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab2INNyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:54:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAMbhsRSaHOgyTn56vQndn0TKh3AT9dk3pRVuJx3qJXWowsLVaA@mail.gmail.com>
References: <1347565754-9534-1-git-send-email-thomas.petazzoni@free-electrons.com>
	<1347599944.9481.3.camel@joe2Laptop>
	<CAMbhsRSaHOgyTn56vQndn0TKh3AT9dk3pRVuJx3qJXWowsLVaA@mail.gmail.com>
Date: Fri, 14 Sep 2012 15:54:31 +0200
Message-ID: <CACRpkdbj=tKBymnHbAmZ=Q_=UuBv+L1g3uM=k=BjjczsFxwt=g@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: use kasprintf() in pinmux_request_gpio()
From: Linus Walleij <linus.walleij@linaro.org>
To: Colin Cross <ccross@google.com>
Cc: Joe Perches <joe@perches.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Maen Suleiman <maen@marvell.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 9:18 AM, Colin Cross <ccross@google.com> wrote:

> The one it's replacing is worse, it never sets gpiostr[15] to 0 and
> kstrdup will read past the end of the buffer if the string is
> truncated.

I recorded this as an Acked-by ... :-)

Yours,
Linus Walleij
