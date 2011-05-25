Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab1EYXqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 19:46:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:40668 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075Ab1EYXqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 19:46:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,270,1304319600"; 
   d="scan'208";a="1826544"
From: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-net@vger.kernel.org" <linux-net@vger.kernel.org>
Date: Wed, 25 May 2011 16:46:44 -0700
Subject: RE: [E1000-devel] 2.6.39: kernel igb and e1000e-1.3.17 driver
	broken?
Thread-Topic: [E1000-devel] 2.6.39: kernel igb and e1000e-1.3.17 driver
	broken?
Thread-Index: AcwbNcvTXdX7cvx8SByeOT+a3yAIkwAABy/Q
Message-ID: <EDC0E76513226749BFBC9C3FB031318F016C14D36B@orsmsx508.amr.corp.intel.com>
References: <alpine.DEB.2.02.1105251926070.9120@p34.internal.lan>
 <alpine.DEB.2.02.1105251941550.9120@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1105251941550.9120@p34.internal.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com]
>Sent: Wednesday, May 25, 2011 4:43 PM
>To: linux-kernel@vger.kernel.org
>Cc: e1000-devel@lists.sourceforge.net; linux-net@vger.kernel.org
>Subject: Re: [E1000-devel] 2.6.39: kernel igb and e1000e-1.3.17 driver
>broken?
>
>
>On Wed, 25 May 2011, Justin Piszcz wrote:
>
>> Hello,
>>
>> I recently bought a 4-port Intel NIC (82580)
>>
>> 03:00.0 Ethernet controller: Intel Corporation 82580 Gigabit Network
>> Connection (rev 01)
>> 03:00.1 Ethernet controller: Intel Corporation 82580 Gigabit Network
>> Connection (rev 01)
>> 03:00.2 Ethernet controller: Intel Corporation 82580 Gigabit Network
>> Connection (rev 01)
>> 03:00.3 Ethernet controller: Intel Corporation 82580 Gigabit Network
>> Connection (rev 01)
>>
>> Model name: Intel I340 Server Adapter
>>
>> Which uses this driver:
>> | |    <M>   Intel(R) 82575/82576 PCI-Express Gigabit Ethernet support
>| |
>> | |    [ ]     Direct Cache Access (DCA) Support
>| |
>>
>> I have tried with and without the DCA support.
>>
>> Out of the four ports in the back, only two work, why is this?
>>
>> [ CARD ]
>> 1 2 3 4
>>  X X
>>
>> Where X = working.
>>
>> I've tried the built-in kernel driver from 2.6.39 as well as the
>latest
>> e1000e driver from sf.net (1.3.17), any thoughts?
>>
>> eth0: negotiated 1000baseT-FD flow-control, link ok <- onboard
>> eth1: negotiated 100baseTx-FD, link ok              <- middle port 1
>> eth2: negotiated 1000baseT-FD flow-control, link ok <- middle port 2
>> eth3: no link                                       <- left most port
>> (plugged in)
>> eth4: no link                                       <- right most port
>> (plugged in)
>>
>> The last two parts of each mac addr:
>>
>> eth1      Link encap:Ethernet  HWaddr XX:XX:XX:XX:3b:f9  WORKING
>> eth2      Link encap:Ethernet  HWaddr XX:XX:XX:XX:3b:fa  WORKING
>> eth3      Link encap:Ethernet  HWaddr XX:XX:XX:XX:3b:f8  no link
>> eth4      Link encap:Ethernet  HWaddr XX:XX:XX:XX:3b:fb  no link
>>
>> Thoughts?
>>
>> Justin.
>>
>
>Whoa,
>
>Sent this out too early =)
>My mistake, configuration error on user end :)
>Problem was interfaces were not initialized properly (not UP).
>Please disregard, sorry for the noise!
>
>eth1: negotiated 100baseTx-FD, link ok
>eth2: negotiated 1000baseT-FD flow-control, link ok
>eth3: negotiated 1000baseT-FD flow-control, link ok
>eth4: negotiated 1000baseT-FD flow-control, link ok
>
>Justin.
>
>
>------------------------------------------------------------------------
>------
>vRanger cuts backup time in half-while increasing security.
>With the market-leading solution for virtual backup and recovery,
>you get blazing-fast, flexible, and affordable data protection.
>Download your free trial now.
>http://p.sf.net/sfu/quest-d2dcopy1
>_______________________________________________
>E1000-devel mailing list
>E1000-devel@lists.sourceforge.net
>https://lists.sourceforge.net/lists/listinfo/e1000-devel
>To learn more about Intel&#174; Ethernet, visit
>http://communities.intel.com/community/wired

No problem Justin, let us know if you still find a problem.

Thanks,

Carolyn

Carolyn Wyborny
Linux Development
LAN Access Division
Intel Corporation


