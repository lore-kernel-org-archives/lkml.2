Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968Ab0KQBss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:48:48 -0500
Received: from mail.ensi-bourges.fr ([195.221.38.25]:41860 "EHLO
	ensi-bourges.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933200Ab0KQBsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:48:47 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Nov 2010 20:48:46 EST
Message-ID: <4CE332F7.2070805@ensi-bourges.fr>
Date: Wed, 17 Nov 2010 02:42:15 +0100
From: Martin Peres <martin.peres@ensi-bourges.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101028 Lanikai/3.1.6
MIME-Version: 1.0
To: bskeggs@redhat.com
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Dave Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nouveau build failure (was Re: Linux 2.6.37-rc2)
References: <AANLkTi=34dJ1HJco8gw=Y+7Ear3mC+XnahqODhnn+56u@mail.gmail.com>	 <20101116125055.74f78634.randy.dunlap@oracle.com> <1289941098.20058.1.camel@nisroch>
In-Reply-To: <1289941098.20058.1.camel@nisroch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 16/11/2010 21:58, Ben Skeggs a écrit :
> On Tue, 2010-11-16 at 12:50 -0800, Randy Dunlap wrote:
>> On Tue, 16 Nov 2010 12:45:43 -0800 Linus Torvalds wrote:
>>
>>> Looks like commit 34e9d85a1aae ("drm/nouveau: Add temperature support
>>> (vbios parsing, readings, hwmon)") didn't make things properly
>>> dependent on CONFIG_HWMON (or do the appropriate "select HWMON" or
>>> whatever).
>>>
>>> Added some collection of hopefully more relevant people to the discussion..
>>>
>>>                    Linus
>>
>> This build error was reported for linux-next on 2010.1011 and 2010.1025,
>> with no replies.
>>
>> Some process fix would be nice to see.
> It's actually been fixed in the nouveau tree, I have to go through and
> get fixes out of it and send them to Dave.
>
> Ben.
Thanks Ben, I should have checked my fix actually went in David's 
drm-fixes branch. I'll try to be more vigilent on this in the future.

Martin
