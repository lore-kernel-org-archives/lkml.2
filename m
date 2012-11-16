Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab2KPKd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 05:33:56 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:16856 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab2KPKdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 05:33:53 -0500
Message-ID: <50A6168F.90105@atmel.com>
Date: Fri, 16 Nov 2012 11:33:51 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Nicolas Royer <nicolas@eukrea.com>, <eric@eukrea.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-crypto@vger.kernel.org>,
        <herbert@gondor.hengli.com.au>, <davem@davemloft.net>
Subject: Re: [PATCH 1/5] ARM: AT91SAM9G45: fix crypto peripherals irq issue
 due to sparse irq support.
References: <1352219463-30360-1-git-send-email-nicolas@eukrea.com> <20121107152729.GE4576@game.jcrosoft.org>
In-Reply-To: <20121107152729.GE4576@game.jcrosoft.org>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 04:27 PM, Jean-Christophe PLAGNIOL-VILLARD :
> On 17:31 Tue 06 Nov     , Nicolas Royer wrote:
>> Spare irq support introduced by commit "8fe82a5 ARM: at91: sparse irq support"
>> involves to add the NR_IRQS_LEGACY offset to irq number.
>>
>> Signed-off-by: Nicolas Royer <nicolas@eukrea.com>
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> Acked-by: Eric Bénard <eric@eukrea.com>
>> Tested-by: Eric Bénard <eric@eukrea.com>
>> Cc: stable@vger.kernel.org # 3.6
> 
> ok will see if we can have it for 3.7

Queued in our at91-fixes pull request for 3.7-final.

Thanks a lot, best regards,
-- 
Nicolas Ferre
