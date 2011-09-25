Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224Ab1IYF1s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 01:27:48 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:50529 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751109Ab1IYF1r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 01:27:47 -0400
MIME-Version: 1.0
In-Reply-To: <20110925040217.GO24631@ponder.secretlab.ca>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-5-git-send-email-mturquette@ti.com> <20110925040217.GO24631@ponder.secretlab.ca>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Sat, 24 Sep 2011 22:27:24 -0700
Message-ID: <CAJOA=zOWMR2R2CjZbnCOWQ_R1ZA+aOUejzm-t8OMzbFmc+U2Hg@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] clk: Add simple gated clock
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, paul@pwsan.com, sboyd@quiinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk, eric.miao@linaro.org,
        richard.zhao@linaro.org, Jamie Iles <jamie@jamieiles.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 24, 2011 at 9:02 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Thu, Sep 22, 2011 at 03:26:59PM -0700, Mike Turquette wrote:
>> From: Jeremy Kerr <jeremy.kerr@canonical.com>
>>
>> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
>> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
>> Signed-off-by: Mike Turquette <mturquette@ti.com>
>> ---
>> Changes since v1:
>> Add copyright header
>> Fold in Jamie's patch for set-to-disable clks
>> Use BIT macro instead of shift
>>
>>  drivers/clk/Kconfig    |    4 ++
>>  drivers/clk/Makefile   |    1 +
>>  drivers/clk/clk-gate.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/clk.h    |   13 ++++++++
>>  4 files changed, 96 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/clk/clk-gate.c
>>
>> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
>> index d8313d7..a78967c 100644
>> --- a/drivers/clk/Kconfig
>> +++ b/drivers/clk/Kconfig
>> @@ -12,3 +12,7 @@ config GENERIC_CLK
>>  config GENERIC_CLK_FIXED
>>       bool
>>       depends on GENERIC_CLK
>> +
>> +config GENERIC_CLK_GATE
>> +     bool
>> +     depends on GENERIC_CLK
>
> I see zero documentation on what a "gated clock" is supposed to be or
> how it works, and there are zero comments in the code.  It's kind of
> hard to review that way, and even harder to use.

Will add Documentation and re-post.

Thanks,
Mike

> g.
>
