Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab1F3RHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 13:07:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55440 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab1F3RHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 13:07:30 -0400
Message-ID: <4E0CAD47.9020709@ti.com>
Date: Thu, 30 Jun 2011 18:07:19 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 0/8] regmap: Generic I2C and SPI register map library
References: <20110630055844.GC796@opensource.wolfsonmicro.com>
In-Reply-To: <20110630055844.GC796@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/06/11 06:58, Mark Brown wrote:
> [This revision of the series has some minor updates to the SPI code.]
> 
> Many I2C and SPI based devices implement register maps on top of the raw
> wire interface.  This is generally done in a very standard fashion by
> devices, resulting in a lot of very similar code in drivers.  For some
> time now ASoC has factored this code out into the subsystem but that's
> only useful for audio devices.  The intention with this series is to
> generalise the concept so that it can be used throughout the kernel.
> 
> It's not intended that this be suitable for all devices - some devices
> have things that are hard to generalise like registers with variable
> size and paging which are hard to support genericly.  At the minute the
> code is focused on the common cases.  It is likely that the same code
> could be used with other buses with similar properties to I2C and SPI.
> 
> Currently only physical I/O is handled, the intention is that once this
> support has been reviewed and merged the generic register cache code
> that ASoC includes will also be factored out too.  For devices with read
> heavy workloads (especially those that need a lot of read/modify/write
> cycles) or which don't support read at all this can provide a useful
> performance improvement and for sparse register maps there's a lot of
> benefit in relatively complex cache code.
> 
> I'm not entirely happy with the implementation currently but am fairly
> happy with the external interfaces.
> 

I'm also happy with the interface and imho the code looks fine for initial integration.  

Regards

Liam
