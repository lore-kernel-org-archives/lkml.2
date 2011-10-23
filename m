Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab1JWQur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 12:50:47 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:49329 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197Ab1JWQuq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 12:50:46 -0400
MIME-Version: 1.0
In-Reply-To: <20111023142458.GE1401@S2100-06.ap.freescale.net>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-3-git-send-email-mturquette@ti.com> <20111023142458.GE1401@S2100-06.ap.freescale.net>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Sun, 23 Oct 2011 09:50:24 -0700
Message-ID: <CAJOA=zM=Sq4aQY4kNFyBv4Loft+ZfW6mhHOwFY_kJt+oVdxr9Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] clk: Implement clk_set_rate
To: Shawn Guo <shawn.guo@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, paul@pwsan.com, grant.likely@secretlab.ca,
        sboyd@quiinc.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk, eric.miao@linaro.org,
        richard.zhao@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 7:24 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> On Thu, Sep 22, 2011 at 03:26:57PM -0700, Mike Turquette wrote:
>> From: Jeremy Kerr <jeremy.kerr@canonical.com>
> [...]
>
>> + * @set_rate Change the rate of this clock. If this callback returns
>> + *           CLK_SET_RATE_PROPAGATE, the rate change will be propagated to
>
> s/CLK_SET_RATE_PROPAGATE/CLK_PARENT_RATE_CHANGE, as suggested by your
> change log above?

Thanks for reviewing.  Will roll into V3 patchset.

Regards,
Mike

>
>> + *           the parent clock (which may propagate again). The requested
>> + *           rate of the parent is passed back from the callback in the
>> + *           second 'unsigned long *' argument.
>> + *
>
> --
> Regards,
> Shawn
>
>
