Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab1IVXSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 19:18:08 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:46232 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238Ab1IVXSF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 19:18:05 -0400
MIME-Version: 1.0
In-Reply-To: <1316730422-20027-1-git-send-email-mturquette@ti.com>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Thu, 22 Sep 2011 16:17:42 -0700
Message-ID: <CAJOA=zP1+GPYZpqLtGsJYyU4_bZCpznovct+xiCqYcDhxHMH=Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] Add a generic struct clk
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        paul@pwsan.com, grant.likely@secretlab.ca, sboyd@quiinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk, eric.miao@linaro.org,
        richard.zhao@linaro.org, Mike Turquette <mturquette@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 3:26 PM, Mike Turquette <mturquette@ti.com> wrote:
> Hi all,
>
> The goal of this series is to provide a cross-platform clock framework
> that platforms can use to model their clock trees and perform common
> operations on them.  Currently everyone re-invents their own clock tree
> inside platform code which makes it impossible for drivers to use the
> clock APIs safely across many platforms and for distro's to compile
> multi-platform kernels which all redefine struct clk and its operations.
>
> This is the second version of the common clock patches which were
> originally posted by Jeremy Kerr and then re-posted with some additional
> patches by Mark Brown.  Mark's re-post didn't have any changes done to
> the original four patches from Jeremy which is why this series is "v2".
>
> The changes in this series are minimal: I've folded in some of Mark's
> fixes and most of the comments posted to his series as well as rebasing
> on top of v3.1-rc7.  The design and functionality hasn't changed much
> since Jeremy posted v1 of this series.  Propagating the rate change up
> to the parent has been removed from clk_set_rate since that needs some
> more thought.  I also dropped Mark's change to append a device's name to
> a clk name since device tree might solve this neatly.  Again more
> discussion around that would be good.

For convenience these patches can be found at:
git://git.linaro.org/people/mturquette/linux.git
v3.1-rc7-clkv2

Regards,
Mike
