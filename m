Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030303Ab2LHTpc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 14:45:32 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46177 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030221Ab2LHTp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 14:45:29 -0500
MIME-Version: 1.0
In-Reply-To: <20121208111629.GG10369@pengutronix.de>
References: <20121124082529.GA7687@core.coreip.homeip.net>
	<20121127074209.GL10369@pengutronix.de>
	<20121127090356.GA25658@core.coreip.homeip.net>
	<20121208111629.GG10369@pengutronix.de>
Date: Sat, 8 Dec 2012 17:45:28 -0200
Message-ID: <CAOMZO5B8UXt+tBg7S1A=sBPQB-tCjVjARfDzNmEV8_m5a-qg0Q@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: eukrea_mbimx27-baseboard - use stock
 get_pendown_state() in ads7846
From: Fabio Estevam <festevam@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        =?UTF-8?B?RXJpYyBCw6luYXJk?= <ebenard@eukrea.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On Sat, Dec 8, 2012 at 9:16 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Tue, Nov 27, 2012 at 01:03:56AM -0800, Dmitry Torokhov wrote:
>> The default implementation matches exactly our custom one so we can switch
>> to using the default one. As a bonus the driver will take care of setting
>> GPIO line for us.
>>
>> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>
> Applied, thanks

Which tree did you apply this against? I cannot see it in git.pengutronix.de.

Regards,

Fabio Estevam
