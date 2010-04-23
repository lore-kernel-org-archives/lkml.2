Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab0DWTxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 15:53:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:47292 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab0DWTxT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 15:53:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ceghS9b895M9bHBAvOwPENS37L7Xn7zk+9/UfnjgR4t0t6IAUqsANvQyVZpr2Wpa6P
         6VxhaaJnyL7DCoNYKFBEU76TjRLQzAX8VE06ktFddjTpcuEELBP2sjwkIyOWnu6u0yWA
         5yOTKmU2BtJEqbhfT2X/GkFk/BRg+Y37uB07w=
MIME-Version: 1.0
In-Reply-To: <201004231827.02817.toralf.foerster@gmx.de>
References: <u2nc4e36d111004230324x7e19b794ifbf1ae3cc157ab2e@mail.gmail.com>
	 <20100423090857.728960b7@virtuousgeek.org>
	 <201004231827.02817.toralf.foerster@gmx.de>
Date: Fri, 23 Apr 2010 21:53:17 +0200
Message-ID: <l2gc4e36d111004231253hbd499551s3ed50eae54eb7aff@mail.gmail.com>
Subject: Re: i915_do_wait_request BUG: unable to handle kernel NULL pointer 
	dereference at (null)
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       eric@anholt.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/23 Toralf Förster <toralf.foerster@gmx.de>:
>
> Jesse Barnes wrote at 18:08:57
>> On Fri, 23 Apr 2010 12:24:25 +0200
>>
>> Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
>> > Hi
>> >
>> > Just tried to boot current vanilla upstream kernel - and got pretty ugly
>> > oops. Here is serial console catch after X-startup:
>> >
>> >
>> > BUG: unable to handle kernel NULL pointer dereference at (null)
>> > IP: [<ffffffffa035de81>] i915_do_wait_request+0x101/0x4f0 [i915]
>> > PGD 139649067 PUD 133b5a067 PMD 0
>> > Oops: 0000 [#1] PREEMPT SMP
>> > last sysfs file:
>> > /sys/devices/virtual/backlight/acpi_video0/actual_brightness CPU 0
>> > Modules linked in: xt_tcpudp bridge stp llc autofs4 sunrpc ipv6
>> > ipt_REJECT xt_physdev xt_state ]
>>
>> Here's the fix I'm testing now.
> works fine here for the ThinkPAd T400.
> Thx.
>
>

Tested-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
