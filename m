Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240Ab2J0QAq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 12:00:46 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33113 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759134Ab2J0QAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 12:00:45 -0400
MIME-Version: 1.0
In-Reply-To: <508BF8A8.9090206@gmail.com>
References: <1351146654-9110-1-git-send-email-rajanikanth.hv@stericsson.com>
	<1351146654-9110-2-git-send-email-rajanikanth.hv@stericsson.com>
	<508BF8A8.9090206@gmail.com>
Date: Sat, 27 Oct 2012 21:30:44 +0530
Message-ID: <CAB4BAkuPE6eSr2+LWTaV9trOnFk-_yt-+x8f6zpum=Ws1UvmmA@mail.gmail.com>
Subject: Re: [PATCH 1/4] mfd: ab8500: add devicetree support for fuelgauge
From: Rajanikanth HV <rajanikanth.hv@linaro.org>
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>,
        linaro-dev@lists.linaro.org, linus.walleij@stericsson.com,
        arnd@arndb.de, patches@linaro.org, linux-kernel@vger.kernel.org,
        anton.vorontsov@linaro.org, STEricsson_nomadik_linux@list.st.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 October 2012 20:37, Francesco Lavra <francescolavra.fl@gmail.com> wrote:
> On 10/25/2012 08:30 AM, Rajanikanth H.V wrote:
>> From: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
>> +     bat_tech = of_get_property(np_bat_supply,
>> +                     "stericsson,battery-type", NULL);
>> +     if (!bat_tech)
>> +             dev_warn(dev, "missing property battery-name/type\n");
>> +
>> +     if (strncmp(bat_tech, "LION", 4) == 0) {
>
> What if bat_tech is NULL?
It will be UNKNOWN
