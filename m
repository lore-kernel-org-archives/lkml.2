Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab2KDXCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 18:02:48 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:55877 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab2KDXCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 18:02:45 -0500
Message-ID: <5096F40B.60509@atmel.com>
Date: Mon, 5 Nov 2012 00:02:35 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <havard@skinnemoen.net>,
        <bhutchings@solarflare.com>, <linux-arm-kernel@lists.infradead.org>,
        <plagnioj@jcrosoft.com>, <patrice.vilchez@atmel.com>,
        <linux-kernel@vger.kernel.org>, <manabian@gmail.com>
Subject: Re: [PATCH] net/at91_ether: fix the use of macb structure
References: <75eb5df193c504e68ebff7d6a6a88d9a1cc678cb.1351591858.git.nicolas.ferre@atmel.com> <1351596628-3405-1-git-send-email-nicolas.ferre@atmel.com> <20121103.150414.707741347606909244.davem@davemloft.net>
In-Reply-To: <20121103.150414.707741347606909244.davem@davemloft.net>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2012 08:04 PM, David Miller :
> From: Nicolas Ferre <nicolas.ferre@atmel.com>
> Date: Tue, 30 Oct 2012 12:30:28 +0100
> 
>> Due to the use of common structure in at91_ether and macb drivers,
>> change the name of DMA descriptor structures in at91_ether as well:
>> dma_desc => macb_dma_desc
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> This does not apply to net-next, respin it if this change is
> still relevant.

This one is not relevant anymore.

Best regards,
-- 
Nicolas Ferre
