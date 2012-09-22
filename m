Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab2IVNlH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 09:41:07 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49704 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab2IVNlF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 09:41:05 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.96.155]
In-Reply-To: <CAJK669Z3YSW85wMXK7if3X8Zb9i1+v_Z2d-UZ1oueYRG4oCDNQ@mail.gmail.com>
References: <1348158776-23858-1-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=WgbZbuf6PYkT4vcpP4VAejT8mN4CO3PFB9Ng-74Q=4iKTrQ@mail.gmail.com>
 <CAJK669YswMUghd6nMA+nnuWsMZps4zNoLP0-6fD29Pa3+CzX-g@mail.gmail.com>
 <CAK=WgbYMjeGb7X9V7G-27iL=p4PhAL+CFsJxAo=F7LJ+2c0fCg@mail.gmail.com> <CAJK669Z3YSW85wMXK7if3X8Zb9i1+v_Z2d-UZ1oueYRG4oCDNQ@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 22 Sep 2012 16:40:44 +0300
Message-ID: <CAK=WgbarKvbwRzjb9E=PEj_qQ46UxxrFTRuU9qOiDYSV+XQFxQ@mail.gmail.com>
Subject: Re: [PATCHv4] remoteproc: Add STE modem driver for remoteproc
To: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 4:33 PM, Sjur Brændeland <sjurbren@gmail.com> wrote:
>>>> It might be safer though to invoke ->setup() in probe/remove, instead
>>>> of in start/stop (just like you essentially did before).
>>>>
>>>> This way we don't assume that stop is always called before remove (as
>>>> assumption that might be implicitly valid today, but may break in the
>>>> future).
>>>>
>>>> If you want, I can just change that before applying.
>>>
>>> Sounds good, please just go ahead and change this before applying.
>>> Thank you.
>>
>> I'm going to squash the below into the patch - please ack before I
>> apply and push - thanks!
>
> Looks good, thanks.
>
> Acked-by: Sjur Brændeland <sjur.brandeland@stericsson.om>

Thanks, applied and pushed to remoteproc's for-next branch.
