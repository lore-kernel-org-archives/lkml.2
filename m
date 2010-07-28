Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab0G1AO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 20:14:56 -0400
Received: from mail.candelatech.com ([208.74.158.172]:40846 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab0G1AOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 20:14:54 -0400
Message-ID: <4C4F767D.4020002@candelatech.com>
Date: Tue, 27 Jul 2010 17:14:53 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.34.1+hacks:  kernel deadlock related to file-IO?
References: <4C4F67B3.50101@candelatech.com> <20100727165146.71e46170@nehalam>
In-Reply-To: <20100727165146.71e46170@nehalam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2010 04:51 PM, Stephen Hemminger wrote:
> On Tue, 27 Jul 2010 16:11:47 -0700
> Ben Greear<greearb@candelatech.com>  wrote:
>
>> NOTE:  This is from a hacked 2.6.34.1 kernel, with
>> a module of my own devising loaded and in active use.
>
> Ben please don't ask LKML for help with problems when
> you have a binary only module loaded...

Yeah, I know..but I spent all day hacking .34 enough to
run lockdep and get those backtraces..and they *might* be
valid.  There's a small chance someone else has seen similar
things but not reported it for whatever reason, so maybe
they will chime in.

And finally, I will attempt to reproduce with some official
kernels, and will report what I find one way or another.

The .34 kernel has been a real bitch to get stable  (You
know things must be bad when my name's on -stable patches),
so I wouldn't be surprised if I'm hitting another real bug.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

