Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab1GZGfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 02:35:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab1GZGfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 02:35:16 -0400
Date: Tue, 26 Jul 2011 08:35:11 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: john stultz <johnstul@us.ibm.com>
Cc: walt <w41ter@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [bisected regression] Partial breakage of forcedeth driver
Message-ID: <20110726063511.GC2073@minipsycho>
References: <4E2CA683.4010005@gmail.com>
 <CANcMJZAAfMV2=rTEi7AVg3Qu8uT1kMEpYpTQ+UwvosNPJ81GfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANcMJZAAfMV2=rTEi7AVg3Qu8uT1kMEpYpTQ+UwvosNPJ81GfA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tue, Jul 26, 2011 at 01:23:59AM CEST, johnstul@us.ibm.com wrote:
>On Sun, Jul 24, 2011 at 4:10 PM, walt <w41ter@gmail.com> wrote:
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
>I'm seeing this too.  Ping responses phase in and out every 10 seconds or so.
>
>Jiri, any thoughts?

Nothing so far. I plan to take a loot at this today. Will keep you guyes
posted.

Jirka

>
>thanks
>-john
