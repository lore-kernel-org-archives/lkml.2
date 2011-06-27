Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab1F0WPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 18:15:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:64529 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979Ab1F0WNt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 18:13:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,434,1304319600"; 
   d="scan'208";a="19395153"
From: "Ronciak, John" <john.ronciak@intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: RE: [E1000-devel] 2.6.39.2: skb_over_panic: kernel BUG at
	net/core/skbuff.c:127!
Thread-Topic: [E1000-devel] 2.6.39.2: skb_over_panic: kernel BUG at
	net/core/skbuff.c:127!
Thread-Index: AQHMNRRAn+oH83kBtkO3cT3CCNgplpTRw7YQ
Date: Mon, 27 Jun 2011 22:13:44 +0000
Message-ID: <D38E8E86660E514AB505863C19C9287C03A525@ORSMSX101.amr.corp.intel.com>
References: <alpine.DEB.2.02.1106271742310.6721@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1106271742310.6721@p34.internal.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.131.214]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to hear of your problem.  Please do not try to relate something that happened on REHL4 to something that is happening in the 2.6.39 .2 kernel.

Is the problem reproducible?  If so, does this happen every time? What interface had what HW associated with it?  The info included below doesn't say.  What in type of traffic was happening on eth2?

Cheers,
John


> -----Original Message-----
> From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com]
> Sent: Monday, June 27, 2011 2:49 PM
> To: linux-kernel@vger.kernel.org
> Cc: e1000-devel@lists.sourceforge.net
> Subject: [E1000-devel] 2.6.39.2: skb_over_panic: kernel BUG at
> net/core/skbuff.c:127!
> 
> Hi,
> 
> Looks like I am not the first one:
> https://bugzilla.redhat.com/show_bug.cgi?id=429868
> 
> Any thoughts on this one?
> http://home.comcast.net/~jpiszcz/20110627/IMG_2703.JPG
> 
> Rough transcription:
> 
> skb_over_panic: text:ffffffff813d711c len:44117 put:44117
> head:ffff880415d40000 data:ffff880415d40040 tail:0xac95 end:0x640
> dev:eth2
> -- [ cut here ] ---
> kernel BUG at net/core/skbuff.c:127!
> invalid opcode: 0000 [#1] SMP
> 
> Was playing a video over samba (eth0) and then the kernel panic'd on
> eth2?
> 
> I use all INTEL controllers:
> 
> 00:19.0 Ethernet controller: Intel Corporation 82578DC Gigabit Network
> Connection (rev 05) 01:00.0 Ethernet controller: Intel Corporation
> 82598EB 10-Gigabit AT2 Server Adapter (rev 01) 03:00.0 Ethernet
> controller: Intel Corporation 82580 Gigabit Network Connection (rev 01)
> 03:00.1 Ethernet controller: Intel Corporation 82580 Gigabit Network
> Connection (rev 01)
> 03:00.2 Ethernet controller: Intel Corporation 82580 Gigabit Network
> Connection (rev 01)
> 03:00.3 Ethernet controller: Intel Corporation 82580 Gigabit Network
> Connection (rev 01)
> 
> Justin.
> 
> 
> -----------------------------------------------------------------------
> -------
> All of the data generated in your IT infrastructure is seriously
> valuable.
> Why? It contains a definitive record of application performance,
> security threats, fraudulent activity, and more. Splunk takes this data
> and makes sense of it. IT sense. And common sense.
> http://p.sf.net/sfu/splunk-d2d-c2
> _______________________________________________
> E1000-devel mailing list
> E1000-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/e1000-devel
> To learn more about Intel&#174; Ethernet, visit
> http://communities.intel.com/community/wired
