Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab2EDLzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 07:55:37 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:33878 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755395Ab2EDLzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 07:55:36 -0400
Message-ID: <4FA3C3B9.3030009@ti.com>
Date: Fri, 04 May 2012 14:55:37 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120503 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 2/3] MFD: twl6040: Allocate IRQ numbers dynamically
References: <1336049665-27777-1-git-send-email-peter.ujfalusi@ti.com> <1336049665-27777-3-git-send-email-peter.ujfalusi@ti.com> <20120503132004.GB14296@sirena.org.uk> <4FA2881B.6010902@ti.com> <20120503145248.GJ3955@opensource.wolfsonmicro.com> <4FA2A08C.5000403@ti.com> <20120503152643.GM3955@opensource.wolfsonmicro.com> <4FA3958A.4080206@ti.com> <20120504090856.GA14230@opensource.wolfsonmicro.com> <4FA3B182.5060001@ti.com> <20120504112204.GE14230@opensource.wolfsonmicro.com>
In-Reply-To: <20120504112204.GE14230@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 02:22 PM, Mark Brown wrote:
>> The OMAP platform related drives has been already converted to use
>> irq_alloc_descs(-1, 0, nr_irqs, 0); to map their range (including GPIO,
>> twl6030, etc).
> 
> How does this work for interrupts on things like SPI and I2C devices?

You mean on devices like twl6040, twl6030, twl4030 (I2C MFD devices)?
Or "irq expander" type of devices?

For the later I'm not sure.

-- 
Péter
