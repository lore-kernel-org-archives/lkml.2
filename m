Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab2JHKk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 06:40:28 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64437 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab2JHKk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 06:40:26 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYTqT=eCOWq7hnymMVg0kab-pkXfv4kxnzSrNCNstpwJw@mail.gmail.com>
References: <1349320509-26930-1-git-send-email-festevam@gmail.com>
	<1349320509-26930-6-git-send-email-festevam@gmail.com>
	<CACRpkdYTqT=eCOWq7hnymMVg0kab-pkXfv4kxnzSrNCNstpwJw@mail.gmail.com>
Date: Mon, 8 Oct 2012 07:40:26 -0300
Message-ID: <CAOMZO5BSGFuSg6rMK5cREi3xb47yBm-mW8PDy36nCub9bsFScg@mail.gmail.com>
Subject: Re: [PATCH 6/6] gpio: gpio-da9052: Convert to the new da9052
 interrupt functions
From: Fabio Estevam <festevam@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        ashish.jangam@kpitcummins.com, dchen@diasemi.com, arnd@arndb.de,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Oct 8, 2012 at 3:20 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Oct 4, 2012 at 5:15 AM, Fabio Estevam <festevam@gmail.com> wrote:
>
>> From: Fabio Estevam <fabio.estevam@freescale.com>
>>
>> Convert to the new da9052 interrupt functions, so that we can get rid of
>> irq_base references.
>>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>
> Applied to my GPIO tree with Mark's ACK.

Patches 1/6 and 2/6 are also needed, otherwise it breaks the build if
only this one gets applied.

Thanks,

Fabio Estevam
