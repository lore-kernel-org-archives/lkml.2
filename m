Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab1CaOMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:12:25 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60139 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab1CaOMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:12:23 -0400
Message-ID: <4D948BC4.6020904@canonical.com>
Date: Thu, 31 Mar 2011 09:12:20 -0500
From: Manoj <manoj.iyer@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: SDHCI: Ricoh [1180:e823] unable to mount MMC cards.
References: <4D93AD5C.1070308@canonical.com>	<m34o6k43c4.fsf@pullcord.laptop.org> <4D93BDA9.1020107@canonical.com> <m3vcz02mi1.fsf@pullcord.laptop.org>
In-Reply-To: <m3vcz02mi1.fsf@pullcord.laptop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi,
>
> On Wed, Mar 30 2011, Manoj wrote:
>>>
>>> * turn on CONFIG_MMC_DEBUG and post output
>>> * see if sdhci.debug_quirks=1 helps
>>
>> It could be that this card does not support MMC cards, it shows up as
>> SDHCI controller and does not mention MMC, or may be they all come up
>> as SDHCI, I dont know enough to make that assessment.
>>
>> Here is the output with debug turned on. Sorry for the flood:
>
> There's no sign of life at all from the card.  Have you tried another
> MMC card to verify that this one isn't broken?  Or the quirks?

Yes, tried it all, I have tried MMC, MMCplus, and quirks. I get the same 
result. At the same time it sees SDHCI just fine.

>
> - Chris.
