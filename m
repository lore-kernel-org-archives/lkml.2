Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1JYG0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 02:26:50 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:33817 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419Ab1JYG0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 02:26:49 -0400
Message-ID: <4EA656A0.4010102@ti.com>
Date: Tue, 25 Oct 2011 11:56:40 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@freescale.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        broonie@opensource.wolfsonmicro.com, patches@linaro.org,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract regulator_init_data
References: <4EA00F7C.1080005@ti.com> <20111021082309.GA337@S2100-06.ap.freescale.net> <4EA13053.7080306@ti.com> <20111021115809.GB337@S2100-06.ap.freescale.net> <4EA4FF6B.2080906@ti.com> <20111024081706.GC8708@ponder.secretlab.ca> <20111024090228.GA1755@S2100-06.ap.freescale.net> <4EA52851.8000203@ti.com> <20111024091158.GB1755@S2100-06.ap.freescale.net> <4EA52C56.3080908@ti.com> <20111024134727.GF1755@S2100-06.ap.freescale.net> <4EA65073.7050205@ti.com>
In-Reply-To: <4EA65073.7050205@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 October 2011 11:30 AM, Rajendra Nayak wrote:
>
> In that case should you not be first converting the mfd driver to
> register regulator devices using DT?
> Thats what we did for OMAP, and hence we always have the of_node
> populated when the regulator devices are probed.
> See this patch from Benoit on how thats done for twl devices..
> http://marc.info/?l=linux-omap&m=131489864814428&w=2

Sorry, that was a link to an older version of the patch.
Here's the latest one from Benoit which he did based
on Arnd's suggestion of using of_platform_populate() directly.

http://marc.info/?l=linux-omap&m=131705623822369&w=2
