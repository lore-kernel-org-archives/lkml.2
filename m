Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab2DRXtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 19:49:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62461 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab2DRXsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 19:48:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120418234042.GB23221@kroah.com>
References: <1332492784-10526-1-git-send-email-myungjoo.ham@samsung.com>
	<1332492784-10526-2-git-send-email-myungjoo.ham@samsung.com>
	<20120418214703.GA31606@kroah.com>
	<CAH9JG2VRas6LWCZSF3BFEsJvOS+6AeYMe_BQh3H18kh_=8CNqg@mail.gmail.com>
	<20120418234042.GB23221@kroah.com>
Date: Thu, 19 Apr 2012 08:48:35 +0900
X-Google-Sender-Auth: leYhL92V6iF7hMJsNck1LtM6mZ4
Message-ID: <CAH9JG2VPhv-i43tx2TSejut39u25RYbHKFAhPiRQpH4DYEEg9g@mail.gmail.com>
Subject: Re: [PATCH v7 1/6] Extcon (external connector): import Android's
 switch class and modify.
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnevag?= <arve@android.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com,
        cw00.choi@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/12, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Apr 19, 2012 at 08:38:06AM +0900, Kyungmin Park wrote:
>> Hi Greg,
>>
>> Can you check the latest extcon at here?
>>
>> http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon
>
> No, please send me patches, that's what I need to have in order to apply
> them.
>
> Always make sure that your patches do not break the build along the
> series, which is what happened here.  Did you not test this?

No, we tested it from kernel 3.2 and generate the patches against the
latest kernel at that time.

Here's another patch based on 3.3-rc4.
http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon-for-next

Anyway, as you want, we will send the extcon patches again without build break.

Thank you,
Kyungmin Park
