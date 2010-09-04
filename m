Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab0IDI5V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 04:57:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42071 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab0IDI5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 04:57:20 -0400
Message-ID: <4C8209E2.3080803@ti.com>
Date: Sat, 04 Sep 2010 10:57:06 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] omap3: make coresight register save across OFF modes
 a sysfs option
References: <13B9B4C6EF24D648824FF11BE896716203BADA0745@dlee02.ent.ti.com> <1280077520-7538-8-git-send-email-virtuoso@slind.org> <20100806123711.GI28519@shisha.kicks-ass.net> <20100806124726.GN23778@atomide.com>
In-Reply-To: <20100806124726.GN23778@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 8/6/2010 2:47 PM, Tony Lindgren wrote:
> * Alexander Shishkin<virtuoso@slind.org>  [100806 15:30]:
>> On Sun, Jul 25, 2010 at 08:05:20 +0300, Alexander Shishkin wrote:
>>> This adds a sysfs file at /sys/power/coresight_save which is used to
>>> control if the ETM and debug components' states should be saved and
>>> restored across OFF modes.
>>
>> The non-omap patches are merged to Russell's tree, so these three are
>> the only remaining.
>>
>> This one won't apply to linux-omap master any more because of the pm44xx
>> in the makefile, but should be ok otherwise. It would still apply to
>> linus' tree.
>>
>> So, should I rediff it, resend it or just drop it, because it's not needed?
>
> Patches look OK to me.

These patches are still using static virtual to physical mapping in 
io.h,  shouldn't we take the opportunity of this series to fix that and 
use ioremap instead?

Or do you prefer to do that in a second step?

Regards,
Benoit
