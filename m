Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540Ab0JVTEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:04:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42563 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759490Ab0JVTEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:04:25 -0400
Message-ID: <4CC1E00A.3010109@ti.com>
Date: Fri, 22 Oct 2010 15:03:38 -0400
From: Cyril Chemparathy <cyril@ti.com>
Reply-To: cyril@ti.com
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Lightning/1.0b1 Thunderbird/3.0.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>, sameo@linux.intel.com
Subject: Re: [PATCH v3 01/12] misc: add driver for sequencer serial port
References: <1287694873-12904-1-git-send-email-cyril@ti.com>	<1287694873-12904-2-git-send-email-cyril@ti.com> <20101022152024.65e8f181@lxorguk.ukuu.org.uk>
In-Reply-To: <20101022152024.65e8f181@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2010 10:20 AM, Alan Cox wrote:
> On Thu, 21 Oct 2010 17:01:02 -0400
> Cyril Chemparathy <cyril@ti.com> wrote:
> 
>> TI's sequencer serial port (TI-SSP) is a jack-of-all-trades type of serial port
>> device.  It has a built-in programmable execution engine that can be programmed
>> to operate as almost any serial bus (I2C, SPI, EasyScale, and others).
>>
>> This patch adds a driver for this controller device.  The driver does not
>> expose a user-land interface.  Protocol drivers built on top of this layer are
>> expected to remain in-kernel.
> 
> I suspect the driver belongs with the mfd drivers not with drivers/misc ?
> 
> otherwise it looks very nice.

Unlike MFDs, this device doesn't have cells with differing
functionality.  Instead it has functionally identical ports that can
operate in a variety of modes.  That said, does this still fit in with
other MFD drivers?  If so, I don't see a problem with moving it there.

Thanks
Cyril.
