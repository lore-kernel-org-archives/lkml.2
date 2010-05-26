Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab0EZNUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:20:13 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:46491 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab0EZNUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:20:10 -0400
Message-ID: <4BFD1FB6.8050405@atmel.com>
Date: Wed, 26 May 2010 15:18:46 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Claudio Scordino <claudio@evidence.eu.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, hskinnemoen@atmel.com,
       linux@maxim.org.za,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC: Rick Bronson <rick@efn.org>, John Nicholls <john@thinlinx.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Sebastian Heutling <Sebastian.Heutling@who-ing.de>,
       Ryan Mallon <ryan@bluewatersys.com>, rmk@arm.linux.org.uk,
       michael trimarchi <michael@evidence.eu.com>
Subject: Re: [PATCH] atmel_serial: Atmel RS485 support v2
References: <4BB053C4.7050700@evidence.eu.com>	<4BB10304.6090006@bluewatersys.com>	<4BB1BF49.2000609@evidence.eu.com>	<4BB252E3.3030703@bluewatersys.com>	<4BBD8C9D.3070401@evidence.eu.com>	<20100408111310.524f7354@lxorguk.ukuu.org.uk> <4BBDD71D.1010700@evidence.eu.com>
In-Reply-To: <4BBDD71D.1010700@evidence.eu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 08/04/2010 15:16, Claudio Scordino :

[..]

> atmel_serial: Atmel RS485 support
> 
> Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
> Signed-off-by: Michael Trimarchi <michael@evidence.eu.com>
> Signed-off-by: Rick Bronson <rick@efn.org>
> Signed-off-by: Sebastian Heutling <Sebastian.Heutling@who-ing.de>
> Tested-by: Sebastian Heutling <Sebastian.Heutling@who-ing.de>
> Reviewed-by: Ryan Mallon <ryan@bluewatersys.com>

Even though I personally did not test this patch I think it is time to
go forward with this very good work.

Considering the number of people involved in this testing and review I
think that we can submit this patch for mainline. Who will handle it?
- do we submit to ARM or serial subsystem ?

Best regards,
-- 
Nicolas Ferre

