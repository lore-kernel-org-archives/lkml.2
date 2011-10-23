Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1JWQvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 12:51:36 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:55621 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335Ab1JWQvf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 12:51:35 -0400
MIME-Version: 1.0
In-Reply-To: <20111023143057.GF1401@S2100-06.ap.freescale.net>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-4-git-send-email-mturquette@ti.com> <20111023143057.GF1401@S2100-06.ap.freescale.net>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Sun, 23 Oct 2011 09:51:14 -0700
Message-ID: <CAJOA=zP9h-2ORvUA8WYTcr_jMbc9Vr4nfcxrW+FAZhjKB58r_w@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] clk: Add fixed-rate clock
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

On Sun, Oct 23, 2011 at 7:30 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> On Thu, Sep 22, 2011 at 03:26:58PM -0700, Mike Turquette wrote:
>> From: Jeremy Kerr <jeremy.kerr@canonical.com>
>> +/* Base clock implementations. Platform clock implementations can use these
>> + * directly, or 'subclass' as approprate */
>> +
> /*
>  * Multiple lines comments
>  */

Thanks for the review Shawn.  Will roll into V3 patchset.

Regards,
Mike

> Regards,
> Shawn
