Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543Ab0HEQ5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 12:57:33 -0400
Received: from mail.candelatech.com ([208.74.158.172]:47683 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab0HEQ53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 12:57:29 -0400
Message-ID: <4C5AED6A.8040602@candelatech.com>
Date: Thu, 05 Aug 2010 09:57:14 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Michael Leun <lkml20100708@newton.leun.net>, Greg KH <greg@kroah.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: NET_NS: unregister_netdevice: waiting for lo to become free (after
 using openvpn)
References: <loom.20100708T183152-326@post.gmane.org>	<20100709235744.GA12752@kroah.com>	<20100710101540.2799c9ef@xenia.leun.net>	<20100710140800.GA20424@kroah.com>	<20100710165208.59272ae6@xenia.leun.net>	<20100710235323.5336f627@xenia.leun.net>	<20100711192939.1c25dcaf@xenia.leun.net>	<20100804153543.56f6ecad@xenia.leun.net>	<20100804214618.GA6289@kroah.com>	<20100805001105.5a3453ed@xenia.leun.net>	<m1lj8l29zm.fsf@fess.ebiederm.org>	<20100805112538.60a46cb1@xenia.leun.net> <m1y6clz8ta.fsf_-_@fess.ebiederm.org>
In-Reply-To: <m1y6clz8ta.fsf_-_@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2010 02:51 AM, Eric W. Biederman wrote:
> Michael Leun<lkml20100708@newton.leun.net>  writes:

>> Unfortunately looks like indefinitely. Never watched longer so far
>> (rebooted soon), but I'm seeing this message now repeated every 10 secs
>> for ~10 minutes on a idle system.
>
> Ugh.  A real bug then.  These can be a pain to track down and fix. I
> think the last one of these I tracked down took a couple of weeks.  I
> will start digging in when I get back from vacation.

I once spent a similar amount of time putting in debug variants that
printed info for each time a netdev was acquired and released.

Maybe a similar logic could be put into the official kernel (and
disabled by default)?

That should save effort in the long run, I'd think.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

