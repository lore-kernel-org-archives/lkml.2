Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab0JOQ6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 12:58:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:14822 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932103Ab0JOQ6u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 12:58:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,336,1283756400"; 
   d="scan'208";a="564278936"
From: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
To: Nikola Ciprich <extmaillist@linuxbox.cz>,
        Linux kernel list <linux-kernel@vger.kernel.org>,
        linux-net maillist <linux-net@vger.kernel.org>,
        e1000-devel list <e1000-devel@lists.sourceforge.net>
CC: "nikola.ciprich@linuxbox.cz" <nikola.ciprich@linuxbox.cz>
Date: Fri, 15 Oct 2010 10:58:15 -0600
Subject: RE: [E1000-devel] 2.6.36-rc7-git2 - panic/GPF: e1000e/vlans?
Thread-Topic: [E1000-devel] 2.6.36-rc7-git2 - panic/GPF: e1000e/vlans?
Thread-Index: ActrZbzEOLfxOuSFSX2i25WHdSB1jQAWuUfg
Message-ID: <EA929A9653AAE14F841771FB1DE5A1366027CEFF1C@rrsmsx501.amr.corp.intel.com>
References: <20101014052242.GA8998@pcnci.linuxbox.cz>
In-Reply-To: <20101014052242.GA8998@pcnci.linuxbox.cz>
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
>From: Nikola Ciprich [mailto:extmaillist@linuxbox.cz]
>Sent: Wednesday, October 13, 2010 10:23 PM
>To: Linux kernel list; linux-net maillist; e1000-devel list
>Cc: nikola.ciprich@linuxbox.cz
>Subject: [E1000-devel] 2.6.36-rc7-git2 - panic/GPF: e1000e/vlans?
>
>Hi,
>when I try to boot 2.6.36-rc7-git2 on one of my machines, it crashes while
>setting up the network.

Thanks for letting us know!

>The setup is quite complex, with bonding, lots of vlans and 3 intel
>adapters (system is quad x86_64)

Could you provide more details about the exact setup and the sequence of 
commands that lead to the crash? If you can narrow it down to the actual 
command that caused the crash that would be very helpful.

Also - are you testing from Linus or net-next tree? If you are not using 
net-next, could you give it a try and see if you can reproduce it there?

>
>snip of lspci:
>06:00.0 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit Ethernet
>Controller (Copper) (rev 01)
>06:00.1 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit Ethernet
>Controller (Copper) (rev 01)
>09:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network
>Connection

Could you provide the output of lspci -vvv and a kernel config?

Thanks,
Emil
