Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab1J0SsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 14:48:07 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:49302 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754639Ab1J0SsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 14:48:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAGamqU4Y9geI/2dsb2JhbAAMN4R3p2ABAQEBAgEjVQEFCwsOBgEDAgIFFgsCAgkDAgECAUUGDQEFAgEBh36jDpIBgTCGOoEUBKYI
X-IronPort-AV: E=Sophos;i="4.69,414,1315195200"; 
   d="scan'208";a="144824322"
Message-ID: <4EA9A763.3000607@teksavvy.com>
Date: Thu, 27 Oct 2011 14:48:03 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: asix usb network driver: nfg
References: <4EA89972.5060101@teksavvy.com> <20111026.194045.2019668159403582571.davem@davemloft.net> <4EA8B283.3010105@teksavvy.com> <20111026.221719.2216112919297458522.davem@davemloft.net>
In-Reply-To: <20111026.221719.2216112919297458522.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-10-26 10:17 PM, David Miller wrote:
> From: Mark Lord <kernel@teksavvy.com>
> Date: Wed, 26 Oct 2011 21:23:15 -0400
> 
>> Any strong advance objections to replacing the in-kernel version
>> with a (fixed) vendor open source version?
> 
> It need to meet the coding etc. standards for inclusion, last
> time I looked at it their driver indeed need a bit of cleaning up.

Yeah, okay -- I've got approval to spend some paid time on the effort,
so I'll have a deeper look at things.

> It's a sad situation, they started with the upstream driver and
> just hacked on it however they pleased in their private copy.
> So now we have this huge divergance and no effort on their part
> to rectify things.

Will there be any issues with "Signed-Off-By" on this?
It's all GPL, by License, but we don't necessarily know who
make what changes to their driver since they forked it.
I don't think that matters much, but then what I think doesn't matter much
either. :)

But it is the only one of the two that's close to working
(and does work when DEBUG messages are enabled -- a timing issue
somewhere that I'll fix).

Thanks David.
