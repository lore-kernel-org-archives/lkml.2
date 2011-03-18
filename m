Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab1CRI3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 04:29:45 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61266 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab1CRI3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 04:29:41 -0400
MIME-Version: 1.0
In-Reply-To: <4E253D605AF50140A55CF6396EC99A241C1F71BA68@EXDCVYMBSTM005.EQ1STM.local>
References: <1297827283-22860-1-git-send-email-bibek.basu@stericsson.com>
	<1297827283-22860-2-git-send-email-bibek.basu@stericsson.com>
	<AANLkTi=Yv1fHVTC-BVBJ3WRPGOmOC3fCJ13G-dCegLYo@mail.gmail.com>
	<AANLkTi=qN=i3VW=VXPQ1PAFTXFgo3O_jqykTkc7A7JLF@mail.gmail.com>
	<AANLkTi=o8CbHjJHZETokQP8bz5SyLnyLLadM4UMyZc=6@mail.gmail.com>
	<AANLkTinU7g4qLVwLwFXyt_j6tmGq-5MC9a-wy_cGvC9Y@mail.gmail.com>
	<AANLkTikwjRgCB8nnkTeZq+AbjQ+ugQz_WMshEFMSFo=_@mail.gmail.com>
	<AANLkTikw87uS4w15ZWZOp8bUU1jYwn1xK4tp5cSrpeYH@mail.gmail.com>
	<20110317191132.GA12824@angua.secretlab.ca>
	<4E253D605AF50140A55CF6396EC99A241C1F71BA68@EXDCVYMBSTM005.EQ1STM.local>
Date: Fri, 18 Mar 2011 09:29:40 +0100
Message-ID: <AANLkTikFfDDyQ+23iw_5Hrawe9METoU90Primnsp=hJ+@mail.gmail.com>
Subject: Re: [PATCH] AB8500 GPIO : Driver for 42 AB8500 GPIO pins
From: Linus Walleij <linus.walleij@linaro.org>
To: Bibek BASU <bibek.basu@stericsson.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 4:38 AM, Bibek BASU <bibek.basu@stericsson.com> wrote:

> I don't know how the latest patch has not reached you. I am reposting the patch and attaching with this mail also.
> Your concern regarding getting gpio irq base address from platform data is addressed in that patch.
> Sorry for the confusion.

Maybe I was following up on the wrong mail thread, I take the blame in
that case :-/

And please save the board support patch for later.

Yours,
Linus Walleij
