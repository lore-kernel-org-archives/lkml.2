Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2LQR4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:56:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:18581 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab2LQR4I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 12:56:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,303,1355126400"; 
   d="scan'208";a="235191824"
From: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: 3.6.10: Intel: ixgbe 0000:01:00.0 eth4: Detected Tx Unit Hang
Thread-Topic: 3.6.10: Intel: ixgbe 0000:01:00.0 eth4: Detected Tx Unit Hang
Thread-Index: Ac3a23nWuJ2cjv71QRiidj+JBQAWDQBo1fxw
Date: Mon, 17 Dec 2012 17:56:04 +0000
Message-ID: <87618083B2453E4A8714035B62D6799225D30338@FMSMSX102.amr.corp.intel.com>
References: <004101cddadb$b890e910$29b2bb30$@lucidpixels.com>
In-Reply-To: <004101cddadb$b890e910$29b2bb30$@lucidpixels.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>owner@vger.kernel.org] On Behalf Of Justin Piszcz
>Sent: Saturday, December 15, 2012 7:49 AM
>To: linux-kernel@vger.kernel.org
>Subject: 3.6.10: Intel: ixgbe 0000:01:00.0 eth4: Detected Tx Unit Hang
>
>Hello,
>
>Kernel 3.6.10, first time I have seen this that I can remember (on 10GbE)
>anyway, is this a known issue with 3.6.10?
>
>When the link went down is when I rebooted/etc the remote host attached on
>the other end.
>I've not changed anything physically with the hardware and have been on
>3.6.0-3.6.9 and noticed this when I moved to 3.6.10.
>
>[10270.229200] ixgbe 0000:01:00.0 eth4: NIC Link is Down
>[10276.124937] ixgbe 0000:01:00.0 eth4: NIC Link is Up 10 Gbps, Flow
>Control: RX/TX
>[24529.430997] ixgbe 0000:01:00.0 eth4: Detected Tx Unit Hang
>[24529.430997]   Tx Queue             <10>
>[24529.430997]   TDH, TDT             <4e>, <51>
>[24529.430997]   next_to_use          <51>
>[24529.430997]   next_to_clean        <4e>
>[24529.430997] tx_buffer_info[next_to_clean]
>[24529.430997]   time_stamp           <10172668f>
>[24529.430997]   jiffies              <101726ea4>
>[24529.431011] ixgbe 0000:01:00.0 eth4: tx hang 1 detected on queue 10,
>resetting adapter
>[24529.431028] ixgbe 0000:01:00.0 eth4: Reset adapter
>
>Thoughts?

I don't believe we have seen Tx hangs in validation. If you could narrow down the conditions that lead to the Tx hang that would help a lot. Also the output of ethtool -S eth4 after the Tx hang occurs can be useful to get an idea of the load on the interface.

Thanks,
Emil


