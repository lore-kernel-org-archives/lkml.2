Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab1DUCEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 22:04:14 -0400
Received: from mail.candelatech.com ([208.74.158.172]:38596 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab1DUCEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 22:04:13 -0400
Message-ID: <4DAF9066.7090906@candelatech.com>
Date: Wed, 20 Apr 2011 19:03:18 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: WARNING at libata-core.c:5015 in 2.6.39-rc3-wl+, then lockup.
 (bisected)
References: <4DA5CF81.4070908@candelatech.com> <4DA5D5D8.8070301@candelatech.com> <4DA5F3BA.3060404@candelatech.com> <4DA87A72.50809@candelatech.com> <4DA88707.4060704@garzik.org> <4DA888D6.40000@candelatech.com>
In-Reply-To: <4DA888D6.40000@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2011 11:05 AM, Ben Greear wrote:
> On 04/15/2011 10:57 AM, Jeff Garzik wrote:
>> On 04/15/2011 01:03 PM, Ben Greear wrote:
>>> Ok, it took a while, but I think I have this thing somewhat bisected.
>>>
>>> Starting at commit 4cc4d24efce4672f9b0e7fa27963770ae602998f, I see
>>> hard-drive
>>> issues. Commits right before this (in git bisect) crash in the
>>> networking code
>>> quite often, but the hard-drive logic seems to work at least.
>>>
>>> In later builds (ie, -rc3), the crashes and warnings are different, but
>>> they have something to do with the file system. It's difficult to bisect
>>> it any better because of all the instability...

I tried today's kernel (39-rc4+) and it seems much more stable on my
system.  So, I think the problem must be fixed.  It appears it was not
fixed in the plain 39-rc4, for what that's worth.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
