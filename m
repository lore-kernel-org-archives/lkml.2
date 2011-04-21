Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab1DUTcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:32:32 -0400
Received: from mail.candelatech.com ([208.74.158.172]:43326 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab1DUTca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:32:30 -0400
Message-ID: <4DB08623.9010905@candelatech.com>
Date: Thu, 21 Apr 2011 12:31:47 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jeff Garzik <jeff@garzik.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: WARNING at libata-core.c:5015 in 2.6.39-rc3-wl+, then lockup.
 (bisected)
References: <4DA5CF81.4070908@candelatech.com> <4DA5D5D8.8070301@candelatech.com> <4DA5F3BA.3060404@candelatech.com> <4DA87A72.50809@candelatech.com> <4DA88707.4060704@garzik.org> <4DA888D6.40000@candelatech.com> <4DAF9066.7090906@candelatech.com> <20110421132529.GC31724@htj.dyndns.org>
In-Reply-To: <20110421132529.GC31724@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2011 06:25 AM, Tejun Heo wrote:
> Hello,
>
> On Wed, Apr 20, 2011 at 07:03:18PM -0700, Ben Greear wrote:
>> I tried today's kernel (39-rc4+) and it seems much more stable on my
>> system.  So, I think the problem must be fixed.  It appears it was not
>> fixed in the plain 39-rc4, for what that's worth.
>
> Hmmm... interesting.  I don't know of any changes which could have
> affected that but then again I've been half offline for the last three
> weeks.  Can you please try to boot earlier kernel and determine
> whether the kernel version difference is actually making the
> difference?

I tried the 39-rc4-wl (wireless-testing) kernel that was based off of
39-rc4, and I see hard-drive read errors there, and eventually
crashes.  I didn't try Linus's 39-rc4.

Yesterday's rc4+ kernel ran fine overnight.

I had previously bisected this to a merge in post 2.6.38 code, but
I never found time to figure out what part of the merge was
funky.  In general, from 2.6.38 to very recently, the kernels
have been very unstable on my systems, with multiple networking
crashes and this block level and/or hard-drive stuff causing
trouble, so it's hard to tell exactly when certain bugs
were introduced.

2.6.38 has been stable, as has 2.6.38-wl.

If there is some other specific commit you'd like me to test
I can do so.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

