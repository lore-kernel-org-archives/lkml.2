Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab2IJPGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:06:31 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36921 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2IJPGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:06:30 -0400
MIME-Version: 1.0
In-Reply-To: <201209101401.06859.arnd@arndb.de>
References: <CAB4BAktQz5MY_AHHWUAhRp7HtEzC3v8uFbP0enx1b7ibJLoZ4Q@mail.gmail.com>
	<201209101401.06859.arnd@arndb.de>
Date: Mon, 10 Sep 2012 08:06:28 -0700
Message-ID: <CACRpkdb4yMCatQRhfWqo=pkWrNjd87ephOdVJeU7oMqnF1UZ2A@mail.gmail.com>
Subject: Re: mfd: Implement devicetree support for AB8500 Btemp
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rajanikanth HV <rajanikanth.hv@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>,
        linus.walleij@stericsson.com, STEricsson_nomadik_linux@list.st.com,
        linaro-dev@lists.linaro.org, Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 7:01 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 10 September 2012, Rajanikanth HV wrote:

>> +               thermister-internal-to-battery = <1>;
>> +               li_ion_9100_battery = <0>;
>
> Boolean properties should be empty when enabled and not present when
> disabled. In this example, one would just write
>
>                 thermister-internal-to-battery;

I also think the proper word is "thermistor":
http://en.wikipedia.org/wiki/Thermistor

Yours,
Linus Walleij
