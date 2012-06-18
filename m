Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab2FRGPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:15:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37045 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2FRGPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:15:16 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkda6FJm4fiQ9w0Mo80_B7W09yCwMdMeqoiDUtkifJ88_RQ@mail.gmail.com>
References: <1339607167-26654-1-git-send-email-fabio.estevam@freescale.com>
	<CACRpkda6FJm4fiQ9w0Mo80_B7W09yCwMdMeqoiDUtkifJ88_RQ@mail.gmail.com>
Date: Mon, 18 Jun 2012 11:45:15 +0530
Message-ID: <CAHdPZaNs87D+x6WUiMMmOtTdLWJoxrUN-FawuVN1F=oKi3Q=ow@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: mxs: Use kfree to fix build error
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, shawn.guo@freescale.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sun, Jun 17, 2012 at 10:56 PM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Wed, Jun 13, 2012 at 7:06 PM, Fabio Estevam
> <fabio.estevam@freescale.com> wrote:
>
>> commit 0bf7481 (pinctrl: pinctrl-mxs: Take care of frees if the kzalloc fails)
>> introduced the following build error:
>>
>> drivers/pinctrl/pinctrl-mxs.c:140:3: error: implicit declaration of function 'free'
>>
>> Use kfree function instead.
>>
>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>
> Applied, hm, Devendra please compile-test your patches ;-)

Sorry again for the build errors. :(

The pinctrl is not selectable even with make allyesconfig. is it for a
different arch than x86?
may i know which cross compiler to use to build the pinctrl subsystem :) ?
>
> thanks,
> Linus Walleij

Thanks,
Devendra
