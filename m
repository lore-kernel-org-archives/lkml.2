Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1GYXhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 19:37:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55947 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab1GYXhq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 19:37:46 -0400
MIME-Version: 1.0
In-Reply-To: <CANcMJZAAfMV2=rTEi7AVg3Qu8uT1kMEpYpTQ+UwvosNPJ81GfA@mail.gmail.com>
References: <4E2CA683.4010005@gmail.com>
	<CANcMJZAAfMV2=rTEi7AVg3Qu8uT1kMEpYpTQ+UwvosNPJ81GfA@mail.gmail.com>
Date: Tue, 26 Jul 2011 09:37:45 +1000
Message-ID: <CALzgn9t7XmxLxuQZic-SZMv0HvMHO+huW_hxREqYwbKdT8VUzg@mail.gmail.com>
Subject: Re: [bisected regression] Partial breakage of forcedeth driver
From: Mike Sampson <mike@sambodata.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 9:23 AM, john stultz <johnstul@us.ibm.com> wrote:
> On Sun, Jul 24, 2011 at 4:10 PM, walt <w41ter@gmail.com> wrote:
>> commit 3326c784c9f492e988617d93f647ae0cfd4c8d09
>> Author: Jiri Pirko <jpirko@>
>> Date:   Wed Jul 20 04:54:38 2011 +0000
>>
>>    forcedeth: do vlan cleanup
>>
>>    - unify vlan and nonvlan rx path
>>    - kill np->vlangrp and nv_vlan_rx_register
>>    - allow to turn on/off rx vlan accel via ethtool (set_features)
>>
>>    Signed-off-by: Jiri Pirko <jpirko@>
>>    Signed-off-by: David S. Miller <davem@>
>>
>> This commit causes networking trouble for my nForce-based motherboard.
>> (Details happily supplied if needed.)
>>
>> I say 'partial' breakage because networking is not completely dead,
>> just limping very slowly :)
>>
>> The simplest test is to ping any host (in my LAN or on the internet,
>> makes no difference).  The replies to my ping come at very irregular
>> intervals, ranging from normal to 5-10 seconds or so, seemingly at
>> random AFAICT.
>
> I'm seeing this too.  Ping responses phase in and out every 10 seconds or so.
>
[snip]

I am seeing similar here. Pings are often being dropped all together
and the network is unusable. Mainboard is an ASUS M2N with NVIDIA
nForce 430 MCP chipset.

Regards,

Mike
