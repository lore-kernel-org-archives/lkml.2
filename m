Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab0E0Iqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 04:46:31 -0400
Received: from borg.asidev.net ([95.141.32.69]:46517 "EHLO borg.asidev.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab0E0Iqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 04:46:30 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 May 2010 04:46:30 EDT
Message-ID: <4BFE2F38.8050200@evidence.eu.com>
Date: Thu, 27 May 2010 10:37:12 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, hskinnemoen@atmel.com,
       linux@maxim.org.za,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Rick Bronson <rick@efn.org>, John Nicholls <john@thinlinx.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Sebastian Heutling <Sebastian.Heutling@who-ing.de>,
       Ryan Mallon <ryan@bluewatersys.com>,
       michael trimarchi <michael@evidence.eu.com>, rmk@arm.linux.org.uk
Subject: Re: [PATCH] atmel_serial: Atmel RS485 support v2
References: <4BB053C4.7050700@evidence.eu.com>	<4BB10304.6090006@bluewatersys.com>	<4BB1BF49.2000609@evidence.eu.com>	<4BB252E3.3030703@bluewatersys.com>	<4BBD8C9D.3070401@evidence.eu.com>	<20100408111310.524f7354@lxorguk.ukuu.org.uk>	<4BBDD71D.1010700@evidence.eu.com> <4BFD1FB6.8050405@atmel.com>
In-Reply-To: <4BFD1FB6.8050405@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre ha scritto:
> Le 08/04/2010 15:16, Claudio Scordino :
>
> [..]
>
>   
>> atmel_serial: Atmel RS485 support
>>
>> Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
>> Signed-off-by: Michael Trimarchi <michael@evidence.eu.com>
>> Signed-off-by: Rick Bronson <rick@efn.org>
>> Signed-off-by: Sebastian Heutling <Sebastian.Heutling@who-ing.de>
>> Tested-by: Sebastian Heutling <Sebastian.Heutling@who-ing.de>
>> Reviewed-by: Ryan Mallon <ryan@bluewatersys.com>
>>     
>
> Even though I personally did not test this patch I think it is time to
> go forward with this very good work.
>
> Considering the number of people involved in this testing and review I
> think that we can submit this patch for mainline. Who will handle it?
> - do we submit to ARM or serial subsystem ?
>   

Hi Nicolas,

    the latest version of the patch has been already merged in the
latest Linus' git tree through Russell King's patchsystem (the maintainer of the
driver never answered to emails...).

Many thanks,

       Claudio



