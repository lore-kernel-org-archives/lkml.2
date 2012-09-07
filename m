Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834Ab2IGNfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:35:03 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:47725 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756724Ab2IGNe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:34:58 -0400
Message-ID: <5049F819.1080101@ti.com>
Date: Fri, 07 Sep 2012 16:35:21 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120903 Thunderbird/15.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Tero Kristo <t-kristo@ti.com>,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 08/14] Input: twl4030-vibra: Support for DT booted
 kernel
References: <1346933541-21547-1-git-send-email-peter.ujfalusi@ti.com> <1346933541-21547-9-git-send-email-peter.ujfalusi@ti.com> <20120906161933.GA18562@core.coreip.homeip.net>
In-Reply-To: <20120906161933.GA18562@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 09/06/2012 07:19 PM, Dmitry Torokhov wrote:
> In patch 6 you added a stub for of_find_node_by_name(), so do you really
> need this #ifdef?

True. I'll resend the series since I left the #ifdef also in other patch.

> Otherwise it looks good.
> 
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Thank you,
Péter
