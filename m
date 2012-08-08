Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416Ab2HHOfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:35:40 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:36988 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754099Ab2HHOfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:35:37 -0400
Message-ID: <50227936.3040701@ti.com>
Date: Wed, 08 Aug 2012 17:35:34 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120723 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Benoit Cousson <b-cousson@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Dmitry Torokhov <dtor@mail.ru>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 04/11] MFD: twl4030-audio: Add DT support
References: <1344418887-5262-1-git-send-email-peter.ujfalusi@ti.com> <1344418887-5262-5-git-send-email-peter.ujfalusi@ti.com> <5022529D.3090406@ti.com> <20120808125252.GR16861@opensource.wolfsonmicro.com>
In-Reply-To: <20120808125252.GR16861@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 03:52 PM, Mark Brown wrote:
> On Wed, Aug 08, 2012 at 01:50:53PM +0200, Benoit Cousson wrote:
> 
>> That being said, since we do have the clock binding now, maybe we should
>> create a clock provider at board level for the sys_clk and thus you will
>> just have to create a phandle to it in your audio description.
> 
> Yes, we should be doing this.

Does this needs the common clock framework on the platform? OMAP3 certainly
does not have it enabled since it has not been adopted.

-- 
Péter
