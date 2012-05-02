Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab2EBOJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 10:09:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39228 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab2EBOJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 10:09:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAAQ0ZWTsdNE7=c8CxPGbqdUKYp5wHa1yVriv2OApEFAqtm43Pg@mail.gmail.com>
References: <1335924760-796-1-git-send-email-rob.lee@linaro.org>
 <1335924760-796-2-git-send-email-rob.lee@linaro.org> <20120502031311.GT2194@S2101-09.ap.freescale.net>
 <CAMXH7KG9DNm4Yv4-YMHdB5-aZ14VKVhnHkwEZVUWpjO9q6Vp8w@mail.gmail.com> <CAAQ0ZWTsdNE7=c8CxPGbqdUKYp5wHa1yVriv2OApEFAqtm43Pg@mail.gmail.com>
From: Rob Lee <rob.lee@linaro.org>
Date: Wed, 2 May 2012 09:09:12 -0500
Message-ID: <CAMXH7KGcFjEXazVJeEmKA+7s2yPJv6tzsrPg0d=SwtgH3A62fQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] ARM: imx: Add common imx cpuidle init functionality.
To: Shawn Guo <shawn.guo@linaro.org>
Cc: kernel@pengutronix.de, amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, jj@chaosbits.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 2, 2012 at 9:07 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On 2 May 2012 21:59, Rob Lee <rob.lee@linaro.org> wrote:
>>>> +             ret = cpuidle_register_device(dev);
>>>> +             if (ret) {
>>>> +                     pr_err("%s: Failed to register cpu %u\n",
>>>> +                             __func__, cpu_id);
>>>
>>> Nit: print ret (error code) too?
>>>
>>
>> I added the printing of the error code based on Sascha's suggestion in
>> v1 of this submission.
>>
> But you did not print "ret" in above pr_err.
>

Argh, sorry, still trying to wake up I guess.  Thanks.

> Regards,
> Shawn
