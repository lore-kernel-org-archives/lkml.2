Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab2LDRS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 12:18:57 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:1822 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab2LDRSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 12:18:55 -0500
Message-ID: <50BE307E.9090904@atmel.com>
Date: Tue, 4 Dec 2012 18:18:54 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Joachim Eastwood <manabian@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] net/macb: Use dmapool to align descriptors on 64bits
References: <1354536914-6315-1-git-send-email-nicolas.ferre@atmel.com> <1354543290.7030.26.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1354543290.7030.26.camel@deadeye.wl.decadent.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 03:01 PM, Ben Hutchings :
> On Mon, 2012-12-03 at 13:15 +0100, Nicolas Ferre wrote:
>> Depending on datapath, some revisions of GEM need
>> 64bits aligned descriptors. Use dmapool to allocate
>> these descriptors.
>> Note that different size between RX and TX rings
>> leads to the creation of two pools.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> [...]
> 
> dma_alloc_coherent() allocates whole pages, which I think is quite
> enough alignment.  You can't save memory by doing this, since each pool
> needs at least one page.  So what is this change meant to achieve?

Well... I guess we can forget this patch then ;-)

Thanks, best regards,
-- 
Nicolas Ferre
