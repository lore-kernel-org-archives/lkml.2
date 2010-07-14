Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab0GNTWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:22:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:52426 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab0GNTWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:22:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,203,1278313200"; 
   d="scan'208";a="638538379"
From: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
To: Nico Schottelius <nico-linux-20100702@schottelius.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>
Date: Wed, 14 Jul 2010 13:22:25 -0600
Subject: RE: e1000e: receives no packets after resume
 (2.6.35-rc3-00262-g984bc96)
Thread-Topic: e1000e: receives no packets after resume
 (2.6.35-rc3-00262-g984bc96)
Thread-Index: AcsaiDS/CyaUolK+RJeykIFybnm7dQJATXjg
Message-ID: <EA929A9653AAE14F841771FB1DE5A1365FF4B057A0@rrsmsx501.amr.corp.intel.com>
References: <20100702072826.GB16856@schottelius.org>
 <AANLkTikO8yXXBC9Wt4LKZeu1JD5TKMOW5reB3jpk8Ahp@mail.gmail.com>
 <20100703081732.GA24281@schottelius.org>
In-Reply-To: <20100703081732.GA24281@schottelius.org>
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

Nico Schottelius wrote:
> Hey Jeff,
> 
> Jeff Kirsher [Fri, Jul 02, 2010 at 02:47:26PM -0700]:
>> On Fri, Jul 2, 2010 at 00:28, Nico Schottelius
>> <nico-linux-20100702@schottelius.org> wrote:
>> [...]
>> Adding the Networking Kernel mailing list (netdev) and Intel Linux
>> LAN Driver mailing list (e1000-patches)...
>> 
>> Would it be possible to get more information about the system/setup?
>> 
>> For example, can you provide the following information:
>>      - full lspci output (lspci -vvv)
>>      - ethtool -i ethX
>>      - dmesg  - after loading the driver and configuring the
>> interfaces 
>>      - kernel config
> 
> Attached!
> 
> Cheers,
> 
> Nico

<snip>

>[   12.228826] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
>[   12.279610] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
>[   12.280200] ADDRCONF(NETDEV_UP): eth0: link is not ready
>[   18.282340] e1000e 0000:00:19.0: eth0: Error reading PHY register

Note the error from your dmesg log. This is a known issue and we are working on it.
In meantime you should be able to w/a it by reloading the driver.

Thanks,
Emil
