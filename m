Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934334Ab1CXVLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:11:30 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51721 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934293Ab1CXVL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:11:28 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+i7pxNQNuiNmd7/2SDQrUu1bVkPdnT0AzOKudYGI
	gnpHfeFWXc5z6F
Message-ID: <4D8BB37B.9040204@gmx.de>
Date: Thu, 24 Mar 2011 22:11:23 +0100
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Xavier Bachelot <xavier@bachelot.org>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] viafb: add VIA slapping capability
References: <1300983180-7343-1-git-send-email-FlorianSchandinat@gmx.de> <1300983180-7343-4-git-send-email-FlorianSchandinat@gmx.de> <4D8B9FBE.6030207@bachelot.org>
In-Reply-To: <4D8B9FBE.6030207@bachelot.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xavier Bachelot schrieb:
> On 03/24/2011 05:13 PM, Florian Tobias Schandinat wrote:
>> This patch introduces dummy functions to execute when we don't know
>> what we should do (due to missing documentation). They do nothing
>> but print a nice message in the log explaining the situation.
>> To trigger this message initial power management support is
>> activated which might save a bit energy by disabling PLL and clock
>> if no device is configured to use them.
>>
>> Note: The message is only shown for the oldest IGPs CLE266 and K400
>>       as for the other platforms there are reasonable assumptions
>>       how it does (hopefully) work.
>>
>> Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
>> ---
> 
>> +static void dummy_set_clock_source(enum via_clksrc source, bool use_pll)
>> +{
>> +	printk(KERN_INFO "Using undocumented set slock soure.\n%s", via_slap);
> 
> 2 typos above.

Indeed. Thanks for pointing it out, fixed.

> Regards,
> Xavier

Regards,

Florian Tobias Schandinat
