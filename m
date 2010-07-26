Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab0GZQNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 12:13:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:25548 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab0GZQNr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 12:13:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,262,1278313200"; 
   d="scan'208";a="538851664"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Marc Haber <mh+linux-kernel@zugschlus.de>,
        Linux Kernel Developers <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Date: Mon, 26 Jul 2010 09:13:45 -0700
Subject: RE: e1000e crashes with 2.6.34.x and ThinkPad T60
Thread-Topic: e1000e crashes with 2.6.34.x and ThinkPad T60
Thread-Index: AcsrF9nUw4QxzyS5QzGoJulGzNgUNwBxPtIQ
Message-ID: <8DD2590731AB5D4C9DBF71A877482A9001623EC48E@orsmsx509.amr.corp.intel.com>
References: <20100724092644.GA13353@torres.zugschlus.de>
In-Reply-To: <20100724092644.GA13353@torres.zugschlus.de>
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

On Saturday, July 24, 2010 2:27 AM, Marc Haber wrote:
> Hi,
> 
> I have a new notebook, a Thinkpad T60, which is freezing in random
> intervals (like 30 minutes to two days) as long as I am using the
> on-board wired ethernet interface, which is an e1000e, [8086:109a]. As
> long as I keep using the WLAN, the system runs for weeks despite
> frequent suspend/resume cycles etc. The crashes seem really to be tied
> to using the wired ethernet. This is a hard freeze, with nothing
> happening on the system, only a long push on the power button helps.
> 
> Additionally, sometimes, probably after suspend/resume, the wired
> ethernet does not come up properly again, ip addr claims "NO CARRIER"
> even if the LEDs on the interface and on the switch claim that there
> was a link. No packets are received by the interface when it's at this
> stage.
> 
> Both issues appear with 2.6.34 and 2.6.34.1. I didn't try any of these
> issues with an older kernel, 2.6.34 was already out when I started
> using the T60.
> 
> To rule out defective hardware, I have tried with a second T60, with
> the same results.
> 
> Full dmesg and lspci-nn attached, please say if you need more.
> 
> Greetings
> Marc
> 
> P.S.: Please Cc: me on replies, both linux-kernel and netdev are too
> big for me to timely follow. I am subscribed to both lists, but a Cc
> helps in getting a faster reply.
> 
> --
> -----------------------------------------------------------------------------
> Marc Haber         | "I don't trust Computers. They | Mailadresse im
> Header Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49
> 621 72739834 Nordisch by Nature |  How to make an American Quilt |
> Fax: *49 3221 2323190 

Adding e1000-devel (the Intel LAN developers list).

Please supply the full dmesg you meant to attach with the original report, as well as the output of lspci -vvv.

Thanks,
Bruce.
