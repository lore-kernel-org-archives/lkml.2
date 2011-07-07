Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab1GGNeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:34:05 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:62291 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab1GGNeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:34:04 -0400
Message-ID: <4E15B529.9070808@mvista.com>
Date: Thu, 07 Jul 2011 17:31:21 +0400
From: Vitaly Kuzmichev <vkuzmichev@mvista.com>
Reply-To: vkuzmichev@mvista.com
Organization: MontaVista Software, LLC
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Thunderbird/3.1.10
MIME-Version: 1.0
To: vkuzmichev@mvista.com
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Wim Van Sebroeck <wim@iguana.be>,
        Marc Zyngier <marc.zyngier@arm.com>, Colin Cross <ccross@android.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/4] ARM: smp_twd: Fix typo in 'twd_timer_rate' printing
References: <1310041339-2348-1-git-send-email-vkuzmichev@mvista.com> <1310041396-2461-1-git-send-email-vkuzmichev@mvista.com> <20110707123907.GP8286@n2100.arm.linux.org.uk> <4E15ABA6.4000202@mvista.com>
In-Reply-To: <4E15ABA6.4000202@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/07/2011 04:50 PM, Vitaly Kuzmichev wrote:
> Hi Russell,
> 
> On 07/07/2011 04:39 PM, Russell King - ARM Linux wrote:
>> On Thu, Jul 07, 2011 at 04:23:13PM +0400, Vitaly Kuzmichev wrote:
>>> To get hundredths of MHz the rate needs to be divided by 10'000.
>>> Here is an example:
>>>  twd_timer_rate = 123456789
>>>  Before the patch:
>>>     twd_timer_rate / 1000000 = 123
>>>     (twd_timer_rate / 1000000) % 100 = 23
>>>     Result: 123.23MHz.
>>>  After being fixed:
>>>     twd_timer_rate / 1000000 = 123
>>>     (twd_timer_rate / 10000) % 100 = 45
>>>     Result: 123.45MHz.
>>>
>>> Signed-off-by: Vitaly Kuzmichev <vkuzmichev@mvista.com>
>>
>> -> patch system please.
> 
> For a such newbie as me it's hard to understand this comment, sorry :)
> Could you explain, please?

Ignore my question, I've learned.

Thanks,
Vitaly.
