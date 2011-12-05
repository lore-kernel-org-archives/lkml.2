Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab1LELhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:37:31 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:64617 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab1LELh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:37:26 -0500
Message-ID: <4EDCACCB.4010608@atmel.com>
Date: Mon, 05 Dec 2011 12:36:43 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, jamie@jamieiles.com
CC: robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org,
        netdev@vger.kernel.org, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/macb: add DT support
References: <1322846050-4543-1-git-send-email-nicolas.ferre@atmel.com> <1322847782-22650-1-git-send-email-nicolas.ferre@atmel.com> <20111202.125832.1208514279272697863.davem@davemloft.net>
In-Reply-To: <20111202.125832.1208514279272697863.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2011 06:58 PM, David Miller :
> From: Nicolas Ferre<nicolas.ferre@atmel.com>
> Date: Fri,  2 Dec 2011 18:43:02 +0100
>
>> From: Jean-Christophe PLAGNIOL-VILLARD<plagnioj@jcrosoft.com>
>>
>> Allow the device tree to provide the mac address and the phy mode.
>>
>> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD<plagnioj@jcrosoft.com>
>> [nicolas.ferre@atmel.com: change "compatible" node property, doc and DT hwaddr]
>> Signed-off-by: Nicolas Ferre<nicolas.ferre@atmel.com>
>> Cc: Jamie Iles<jamie@jamieiles.com>
>> ---
>> v2: modify macb_get_hwaddr_dt() parameter
>
> You'll have to respin these two macb patches, as they don't apply properly
> to the net-next tree which is where they should be targetted.

David,

In fact, the patches are designed to be added on top of Jamie's rework 
of the macb driver that is now in Arnd's "arm-soc" git tree (for-next 
branch). You discussed with him here:

http://www.spinics.net/lists/arm-kernel/msg118717.html

Should I go this path also or wait for this material to be merged and 
update on net-next at this time (after 3.3 merge window...)?

Best regards,
-- 
Nicolas Ferre
