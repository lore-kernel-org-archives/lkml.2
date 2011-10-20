Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab1JTMLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 08:11:05 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:38267 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043Ab1JTMLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 08:11:04 -0400
Message-ID: <4EA00FCE.4010807@ti.com>
Date: Thu, 20 Oct 2011 17:40:54 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: patches@linaro.org, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        lrg@ti.com, Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract regulator_init_data
References: <1318263578-7407-4-git-send-email-rnayak@ti.com> <20111016145536.GA29885@S2100-06.ap.freescale.net> <4E9BAC4D.3010402@ti.com> <20111018115836.GC30703@S2100-06.ap.freescale.net> <20111018160046.GD28501@opensource.wolfsonmicro.com> <20111019053354.GB31162@S2100-06.ap.freescale.net> <20111019144734.GI18713@sirena.org.uk> <20111019150448.GB32007@S2100-06.ap.freescale.net> <20111019151031.GA4275@opensource.wolfsonmicro.com> <4E9F9892.9070007@ti.com> <20111020094140.GK18713@sirena.org.uk>
In-Reply-To: <20111020094140.GK18713@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> We can always start off just completely omitting the data and then see
> how we go from there.  If we only cover 50% of users that's still 50%
> more than are currently covered with device tree right now and it means
> we can then spin round and look at the bits that are hard again without
> review fatigue on the bits that are easy.

Ok, will drop the problematic bindings for now and repost.

