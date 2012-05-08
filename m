Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab2EHLoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 07:44:11 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:47121 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752735Ab2EHLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 07:44:09 -0400
Message-ID: <4FA90717.4050407@ti.com>
Date: Tue, 08 May 2012 14:44:23 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120503 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v2 2/3] MFD: twl6040: Allocate IRQ numbers dynamically
References: <1336476810-26945-1-git-send-email-peter.ujfalusi@ti.com> <1336476810-26945-3-git-send-email-peter.ujfalusi@ti.com> <20120508114019.GJ15893@opensource.wolfsonmicro.com>
In-Reply-To: <20120508114019.GJ15893@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 02:40 PM, Mark Brown wrote:
> On Tue, May 08, 2012 at 02:33:29PM +0300, Peter Ujfalusi wrote:
> 
>> The client drivers will receive their interrupt numbers via pdata which
>> is configured based on the received IRQ range we got from irq_alloc_descs()
> 
> The idiomatic thing is to use resources and have mfd_add_devices() do
> the fixup, which actually appears to be what the code is doing so no
> problem.

True, the irq numbers are passed as resource for the device. I should
probably rephrase the message since the mention of pdata is clearly
wrong in this context...

-- 
Péter
