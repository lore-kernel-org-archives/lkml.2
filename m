Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab0JNUe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 16:34:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27597 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab0JNUe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 16:34:58 -0400
Message-ID: <4CB768F7.90009@oracle.com>
Date: Thu, 14 Oct 2010 13:32:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rpurdie@rpsys.net
Subject: Re: mmotm 2010-10-13-17-13 uploaded (leds)
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org>	 <20101013212902.2fec6413.randy.dunlap@oracle.com>	 <1287056312.4641.296.camel@jlt3.sipsolutions.net>	 <4CB72C62.1030204@oracle.com> <1287087217.4641.442.camel@jlt3.sipsolutions.net>
In-Reply-To: <1287087217.4641.442.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/10 13:13, Johannes Berg wrote:
> On Thu, 2010-10-14 at 09:14 -0700, Randy Dunlap wrote:
> 
>>> Are there dependencies missing? I was under the impression that this
>>> shouldn't be happening. And what's the point in having triggers, but
>>> nothing to trigger...? How about the patch below?
>>
>> It seems to be due to net/mac80211/Kconfig:
>>
>> config MAC80211_LEDS
>> 	bool "Enable LED triggers"
>> 	depends on MAC80211
>> 	select NEW_LEDS
>> 	select LEDS_TRIGGERS
> 
> Ohh. Indeed, that should be easy to fix, make it depend on
> LEDS_TRIGGERS=y || LEDS_TRIGGERS=MAC80211 or so?

Yes.

>>> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
>>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>>
>> The patch does not apply cleanly to mmotm, but it seems
>> like a good plan...
> 
> Hmm, ok, it was against the latest -rc or so. It'll have to wait a bit,
> I'm about to leave for a week. Sorry!

No problem.

later,
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
