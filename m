Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab0K0C5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 21:57:16 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:4955 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752031Ab0K0C5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 21:57:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAA4C8ExLd/sX/2dsb2JhbAAHg0nOe5BJgSGBUIFjcwSEXIsZ
X-IronPort-AV: E=Sophos;i="4.59,264,1288584000"; 
   d="scan'208";a="83844594"
Message-ID: <4CF07386.7080304@teksavvy.com>
Date: Fri, 26 Nov 2010 21:57:10 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Tobias Karnat <tobias.karnat@googlemail.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: sata_sil24: external raid storage mistaken as port multiplier
References: <1290461073.12443.21.camel@Tobias-Karnat>	 <1290514125.28293.2.camel@Tobias-Karnat> <1290572588.24847.20.camel@Tobias-Karnat> <4CEFEC17.6060503@kernel.org> <4CF014F8.9000700@teksavvy.com> <4CF01583.5050307@kernel.org>
In-Reply-To: <4CF01583.5050307@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-11-26 03:16 PM, Tejun Heo wrote:
> Hello,
>
> On 11/26/2010 09:13 PM, Mark Lord wrote:
>>> That said, yeah, it probably would be a good idea to add a
>>> libata.force param.
>>
>> How about some form of auto-detection instead?
>
> That's a device which reports that it's a PMP but fails to behave
> itself as one.  The sucky thing is that depending on the current mode
> and firmware revision, the same hardware can actually bahave as a
> pretty decent PMP.

Yuck!  :)

I suppose *if* we knew the exact fwrev that requires the workaround,
then we could make it automatic for that, and still have the boot flag
for cases we don't know about.

Tobias?  Got the IDENTIFY info from that device?
Something like "hdparm --istdout /dev/sdX"  ?
