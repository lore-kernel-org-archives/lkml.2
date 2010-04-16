Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab0DPLwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 07:52:38 -0400
Received: from mail2.donator.se ([217.16.195.8]:2493 "EHLO mail2.donator.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757929Ab0DPLwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 07:52:37 -0400
X-MDAV-Processed: mail2.donator.se, Fri, 16 Apr 2010 13:52:35 +0200
X-Spam-Processed: mail2.donator.se, Fri, 16 Apr 2010 13:52:34 +0200
	(not processed: spam filter heuristic analysis disabled)
X-Authenticated-Sender: jakob.viketoft@bitsim.com
X-MDRemoteIP: 10.99.195.158
X-Return-Path: jakob.viketoft@bitsim.com
X-Envelope-From: jakob.viketoft@bitsim.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <4BC84F7F.2020309@bitsim.com>
Date: Fri, 16 Apr 2010 13:52:31 +0200
From: Jakob Viketoft <jakob.viketoft@bitsim.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: daniel@caiaq.de
CC: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH] colibri.h: #include corrections
References: <4BC84DEC.2000806@bitsim.com> <20100416114830.GO30801@buzzloop.caiaq.de>
In-Reply-To: <20100416114830.GO30801@buzzloop.caiaq.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Reply-To: jakob.viketoft@bitsim.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack wrote:
> On Fri, Apr 16, 2010 at 01:45:48PM +0200, Jakob Viketoft wrote:
>> The use of mfp_cfg_t causes build errors without including
>> <mach/mfp.h>. The include for the ax88796 is kicked as well since
>> it's inclusion is obsoleted as adviced by Daniel Mack.
> 
> Argh, I'm sorry. This time, I was too fast. The ax88796 must stay, I
> overlooked the use of ax_plat_data.
> 
> Daniel

There's gremlins in here somewhere, I'm sure. ;) I'll try one more time...

	/Jakob

> 
>> CC: stable@kernel.org
>> CC: Daniel Mack <daniel@caiaq.de>
>> CC: Eric Miao <eric.y.miao@gmail.com>
>> Signed-off-by Jakob Viketoft <jakob.viketoft@bitsim.com>
> 
>> --- a/arch/arm/mach-pxa/include/mach/colibri.h	2010-03-15
>> 17:09:39.000000000 +0100
>> +++ b/arch/arm/mach-pxa/include/mach/colibri.h	2010-04-16
>> 13:30:43.000000000 +0200
>> @@ -1,7 +1,7 @@
>>  #ifndef _COLIBRI_H_
>>  #define _COLIBRI_H_
>>
>> -#include <net/ax88796.h>
>> +#include <mach/mfp.h>
>>
>>  /*
>>   * common settings for all modules
>>
> 

