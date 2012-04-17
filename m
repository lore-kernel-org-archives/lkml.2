Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab2DQDu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 23:50:58 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:36067 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755791Ab2DQDu4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 23:50:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAAQ0ZWRg2jwNZ7Bx5j5NtCVveT_085VmFtPMhWW62-aO+kFfnw@mail.gmail.com>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
 <1334192572-12499-14-git-send-email-mturquette@linaro.org>
 <20120412064920.GH2445@S2101-09.ap.freescale.net> <CAJOA=zMPQK-W_nbRztXCNdLHoTJU73ZnrxAS8VvvmzgdaVS2mQ@mail.gmail.com>
 <CAAQ0ZWRg2jwNZ7Bx5j5NtCVveT_085VmFtPMhWW62-aO+kFfnw@mail.gmail.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Mon, 16 Apr 2012 20:50:32 -0700
Message-ID: <CAJOA=zPnQhq_3O00F4dfUbnywW-Riov7N76F3wraE67yy2MMuA@mail.gmail.com>
Subject: Re: [PATCH 13/13] clk: basic: improve parent_names & return errors
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>, Rajendra Nayak <rnayak@ti.com>,
        linux-kernel@vger.kernel.org, Saravana Kannan <skannan@codeaurora.org>,
        Olof Johansson <olof@lixom.net>, linaro-dev@lists.linaro.org,
        arnd.bergmann@linaro.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 6:46 PM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On 17 April 2012 07:10, Turquette, Mike <mturquette@ti.com> wrote:
> ...
>> Yes, this was a braindead change on my part.  I'll remove the kstrdup
>> in my next series (the rest of this patch will stay in).
>>
> Do you have an ETA on that?  A few platform porting are waiting for a
> stable branch with all necessary fixup/cleanup integrated to publish
> the patches.

That is a good question.  I think it is worth waiting on Saravana's
patch which exposes non-private members of struct clk via struct
clk_hw.  This will have an effect on both platform clock data and
code.

I do not think that there is a point in pushing another series out
until I get that in since it will shake things up for platforms trying
to convert over.  And due to the invasive nature I'm still not sure if
this stuff will go into an -rc or some -next branch for 3.5.  I don't
see the harm in keeping it in a -next branch for 3.5 where all
platforms can base on that branch since they will be queuing up for
3.5 anyway.

Regards,
Mike

> Regards,
> Shawn
