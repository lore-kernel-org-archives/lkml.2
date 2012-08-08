Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab2HHPmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:42:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49744 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345Ab2HHPmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:42:11 -0400
Message-ID: <502288BB.6020709@ti.com>
Date: Wed, 8 Aug 2012 17:41:47 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>, Dmitry Torokhov <dtor@mail.ru>,
        <alsa-devel@alsa-project.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 04/11] MFD: twl4030-audio: Add DT support
References: <1344418887-5262-1-git-send-email-peter.ujfalusi@ti.com> <1344418887-5262-5-git-send-email-peter.ujfalusi@ti.com> <5022529D.3090406@ti.com> <20120808125252.GR16861@opensource.wolfsonmicro.com> <50227936.3040701@ti.com>
In-Reply-To: <50227936.3040701@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 04:35 PM, Peter Ujfalusi wrote:
> On 08/08/2012 03:52 PM, Mark Brown wrote:
>> On Wed, Aug 08, 2012 at 01:50:53PM +0200, Benoit Cousson wrote:
>>
>>> That being said, since we do have the clock binding now, maybe we should
>>> create a clock provider at board level for the sys_clk and thus you will
>>> just have to create a phandle to it in your audio description.
>>
>> Yes, we should be doing this.
> 
> Does this needs the common clock framework on the platform? OMAP3 certainly
> does not have it enabled since it has not been adopted.
> 

Yeah, good point, we are still not there yet. Rajendra is still working
on it and I hope we can get something for 3.7, but let's avoid having a
strong dependency on that migration for the moment.

Regards,
Benoit
