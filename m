Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964812Ab2JZPZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:25:18 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:18511 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933811Ab2JZPZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:25:13 -0400
Message-ID: <508AAB54.9010506@atmel.com>
Date: Fri, 26 Oct 2012 17:25:08 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <davem@davemloft.net>, Joachim Eastwood <manabian@gmail.com>
CC: <netdev@vger.kernel.org>, <havard@skinnemoen.net>,
        <bhutchings@solarflare.com>, <linux-arm-kernel@lists.infradead.org>,
        <plagnioj@jcrosoft.com>, <patrice.vilchez@atmel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/9] net/macb: driver enhancement concerning GEM support,
 ring logic and cleanup
References: <cover.1348055112.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1348055112.git.nicolas.ferre@atmel.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On 09/19/2012 01:55 PM, Nicolas Ferre :
> This is an enhancement work that began several years ago. I try to catchup with
> some performance improvement that has been implemented then by Havard.
> The ring index logic and the TX error path modification are the biggest changes
> but some cleanup/debugging have been added along the way.
> The GEM revision will benefit from the Gigabit support.
> 
> The series has been tested on several Atmel AT91 SoC with the two MACB/GEM
> flavors.
> 
> v2: - modify the tx error handling: now uses a workqueue
>     - information provided by ethtool -i were not accurate: removed

I am about to re-send this patch series. Should I rebase it on top of
Joachim's recent modifications? I mean, I plan to rebase them on top of
net-next, is it the proper thing to do?

> Havard Skinnemoen (4):
>   net/macb: memory barriers cleanup
>   net/macb: change debugging messages
>   net/macb: clean up ring buffer logic
>   net/macb: Offset first RX buffer by two bytes
> 
> Nicolas Ferre (4):
>   net/macb: remove macb_get_drvinfo()
>   net/macb: tx status is more than 8 bits now
>   net/macb: ethtool interface: add register dump feature
>   net/macb: better manage tx errors
> 
> Patrice Vilchez (1):
>   net/macb: Add support for Gigabit Ethernet mode
> 
>  drivers/net/ethernet/cadence/macb.c | 433 +++++++++++++++++++++++++-----------
>  drivers/net/ethernet/cadence/macb.h |  30 ++-
>  2 files changed, 321 insertions(+), 142 deletions(-)

Best regards,
-- 
Nicolas Ferre
