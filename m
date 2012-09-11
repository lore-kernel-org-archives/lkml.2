Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381Ab2IKVJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 17:09:53 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:38576 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758118Ab2IKVJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 17:09:51 -0400
Date: Tue, 11 Sep 2012 23:09:49 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH] wdt:clk: preparation for switch to common clock framework
Message-ID: <20120911210949.GI27604@spo001.leaseweb.com>
References: <1346351350-28807-1-git-send-email-m-karicheri2@ti.com> <3E54258959B69E4282D79E01AB1F32B7041B6EB8@DFLE12.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3E54258959B69E4282D79E01AB1F32B7041B6EB8@DFLE12.ent.ti.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Karicheri,

> >> -----Original Message-----
> >> From: Karicheri, Muralidharan
> >> Sent: Thursday, August 30, 2012 2:29 PM
> >> To: linux-kernel@vger.kernel.org; mturquette@linaro.org; linux-
> >> watchdog@vger.kernel.org; wim@iguana.be
> >> Cc: Karicheri, Muralidharan
> >> Subject: [PATCH] wdt:clk: preparation for switch to common clock framework
> >> 
> >> As a first step towards migrating davinci platforms to use common clock
> >> framework, replace all instances of clk_enable() with clk_prepare_enable()
> >> and clk_disable() with clk_disable_unprepare(). Until the platform is
> >> switched to use the CONFIG_HAVE_CLK_PREPARE Kconfig variable, this just
> >> adds a might_sleep() call and would work without any issues.
> >> 
> >> This will make it easy later to switch to common clk based implementation
> >> of clk driver from DaVinci specific driver.
> >> 
> >> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Could you resent the original e-mail because I didn't seem to have received it...
And I can't even find it in the linux-watchdog mailing list archives...

Thanks,
Wim.

