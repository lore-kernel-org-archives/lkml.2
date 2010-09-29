Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab0I2Hdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 03:33:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44399 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab0I2Hdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 03:33:44 -0400
Message-ID: <4CA2EBC3.3030509@monstr.eu>
Date: Wed, 29 Sep 2010 17:33:23 +1000
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: microblaze-uclinux@itee.uq.edu.au
CC: grant.likely@secretlab.ca, monstr@monstr.eu, linux-kernel@vger.kernel.org,
        john.williams@petalogix.com, edgar.iglesias@gmail.com, duyl@xilinx.com,
        linnj@xilinx.com, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 4/7] net: emaclite: Add support for little-endian platforms
References: <1285739538-29058-4-git-send-email-monstr@monstr.eu>	<1285739538-29058-5-git-send-email-monstr@monstr.eu>	<20100929061146.GA2439@angua.secretlab.ca> <20100928.232722.189705899.davem@davemloft.net>
In-Reply-To: <20100928.232722.189705899.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



David Miller wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> Date: Wed, 29 Sep 2010 15:11:46 +0900
> 
>> On Wed, Sep 29, 2010 at 03:52:15PM +1000, Michal Simek wrote:
>>> Upcomming Microblaze is little endian that's why is necessary
>>> to fix protocol and length loading.
>>>
>>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>>> CC: "David S. Miller" <davem@davemloft.net>
>>> CC: Grant Likely <grant.likely@secretlab.ca>
>>> CC: Eric Dumazet <eric.dumazet@gmail.com>
>>> CC: netdev@vger.kernel.org
>>> CC: linux-kernel@vger.kernel.org
>>> CC: devicetree-discuss@lists.ozlabs.org
>> This should go via davem, but it looks correct to me.
>>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
> It doesn't need to, the microblaze guys can integrate this directly:
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks for ACKs. I will add them and will take care about it.

Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
