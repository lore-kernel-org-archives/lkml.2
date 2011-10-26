Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1JZDNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 23:13:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42837 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab1JZDNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 23:13:04 -0400
Message-ID: <4EA77ABB.40503@numascale-asia.com>
Date: Wed, 26 Oct 2011 11:12:59 +0800
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>, H Peter Anvin <hpa@zytor.com>,
        Steffen Persvold <sp@numascale.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 3/3] Add NumaChip quirk
References: <1318926156-25504-1-git-send-email-daniel@numascale-asia.com> <1318926156-25504-3-git-send-email-daniel@numascale-asia.com> <alpine.LFD.2.02.1110251550430.21837@ionos>
In-Reply-To: <alpine.LFD.2.02.1110251550430.21837@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/10/2011 21:54, Thomas Gleixner wrote:
> Daniel,
>
> On Tue, 18 Oct 2011, Daniel J Blueman wrote:
>
>> Add quirk for Numascale's NumaChip to prevent resource conflicts.
>>
>> v2:
>>   - [Daniel] rediffed and validated against 3.1-rc10
>>
>> Signed-off-by: Steffen Persvold<sp@numascale.com>
> So, who wrote that code? If Steffen, then you should put a From:
> .... when sending patches.
Steffen wrote the code; I reviewed and addressed compliance issues 
(hence the Signed-off-by ordering).

I'll add the From header and send the patches again.

Thanks Thomas,
   Daniel

-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia

