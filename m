Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab2JIMEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:04:39 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52195 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab2JIMEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:04:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5BSGFuSg6rMK5cREi3xb47yBm-mW8PDy36nCub9bsFScg@mail.gmail.com>
References: <1349320509-26930-1-git-send-email-festevam@gmail.com>
	<1349320509-26930-6-git-send-email-festevam@gmail.com>
	<CACRpkdYTqT=eCOWq7hnymMVg0kab-pkXfv4kxnzSrNCNstpwJw@mail.gmail.com>
	<CAOMZO5BSGFuSg6rMK5cREi3xb47yBm-mW8PDy36nCub9bsFScg@mail.gmail.com>
Date: Tue, 9 Oct 2012 14:04:33 +0200
Message-ID: <CACRpkdZKjOxe3U76+HRrsMU3MBw8TqELWyTug2ciyuS9=FBi5w@mail.gmail.com>
Subject: Re: [PATCH 6/6] gpio: gpio-da9052: Convert to the new da9052
 interrupt functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        ashish.jangam@kpitcummins.com, dchen@diasemi.com, arnd@arndb.de,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 12:40 PM, Fabio Estevam <festevam@gmail.com> wrote:

> Hi Linus,
> On Mon, Oct 8, 2012 at 3:20 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Thu, Oct 4, 2012 at 5:15 AM, Fabio Estevam <festevam@gmail.com> wrote:
>>
>>> From: Fabio Estevam <fabio.estevam@freescale.com>
>>>
>>> Convert to the new da9052 interrupt functions, so that we can get rid of
>>> irq_base references.
>>>
>>> Cc: Grant Likely <grant.likely@secretlab.ca>
>>> Cc: Linus Walleij <linus.walleij@linaro.org>
>>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>>
>> Applied to my GPIO tree with Mark's ACK.
>
> Patches 1/6 and 2/6 are also needed, otherwise it breaks the build if
> only this one gets applied.

Ah OK I'll take it out again. Push this through whatever tree you
want (maybe the i.MX or MFD tree then?)

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Linus Walleij
