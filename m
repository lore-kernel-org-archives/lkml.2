Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1EWIJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 04:09:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50937 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab1EWIJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 04:09:53 -0400
Message-ID: <4DDA1647.9060502@ti.com>
Date: Mon, 23 May 2011 09:09:43 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "grant@secretlab.ca" <grant@secretlab.ca>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCHv5 2/4] TPS65910: GPIO: Add GPIO driver
References: <2CAE1D41-48DC-457F-8FF3-E45B17AC3E0F@slimlogic.co.uk> <4DBAD7E8.8090703@ti.com> <20110429220651.GG7497@ponder.secretlab.ca> <20110513184153.GZ8970@sortiz-mobl> <20110515212044.GB30725@angua.secretlab.ca> <20110522204404.GJ18610@sortiz-mobl>
In-Reply-To: <20110522204404.GJ18610@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/05/11 21:44, Samuel Ortiz wrote:
> Hi Grant,
> 
> On Sun, May 15, 2011 at 03:20:44PM -0600, Grant Likely wrote:
>>> Would you be ok with moving this one to drivers/gpio/ ? And in general, moving
>>> most of the GPIO drivers under drivers/mfd/ back to drivers/gpio/ ?
>>> David didn't want to take the basic MFD related GPIO drivers, that's why we
>>> have several of them under mfd.
>>
>> Yes, move them to GPIO.  That is where they belong.
> Thanks, I'll prepare that for the next merge window.
> 

Ah, I thought you acked the whole series here and applied it yesterday. I can remove this one if required.

Thanks

Liam 
