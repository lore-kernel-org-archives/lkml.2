Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab1EFWZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 18:25:33 -0400
Received: from mail.candelatech.com ([208.74.158.172]:48311 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1EFWZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 18:25:32 -0400
Message-ID: <4DC4755B.3010109@candelatech.com>
Date: Fri, 06 May 2011 15:25:31 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: repeatable 2.6.39-rc6+ lockup on Via C3 system
References: <4DC468AD.70202@candelatech.com>
In-Reply-To: <4DC468AD.70202@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2011 02:31 PM, Ben Greear wrote:
> I have a reproducible lockup on a Via C3 board (with kernel compiled for
> C3).
>
> This kernel has some wireless patches and the slub fix from a few days ago.
>
> Same kernel (compiled for P-II, SMP, pre-empt) works fine on an Atom
> system.
>
> Shortly after the login prompt I see this on serial console:
>
> BUG: spinlock lockup on CPU#0, net.hotplug/1899, f5a2c470
>
> I tried enabling lockdep and saw no splats.
>
> I'm not sure why there isn't more of a backtrace...

Nevermind..it printed out a stack trace the next time.

Bug is un-initialized spinlock in ath5k...I sent a patch to the wireless
mailing list...

Ben

>
> Thanks,
> Ben
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

