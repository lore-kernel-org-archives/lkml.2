Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab2KHTDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:03:19 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:38352 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab2KHTDS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:03:18 -0500
From: "Chini, Georg (HP App Services)" <georg.chini@hp.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [REGRESSION] Kernel 3.5 to 3.7-rc4 / GMA500 / DPMS sometimes
 crashes system
Thread-Topic: [REGRESSION] Kernel 3.5 to 3.7-rc4 / GMA500 / DPMS sometimes
 crashes system
Thread-Index: Ac2juQFVn+V67GgiRmOwkCLDpckQtQaJJ9fw
Date: Thu, 8 Nov 2012 19:02:33 +0000
Message-ID: <B3A09DD14C7DC341B8B4D309FE5DD1BE1515A4D4@G2W2525.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.193.232.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have an issue with the GMA500 driver for kernels from 3.5 up to 3.7-rc4.
I am using an Intel board with a D2700 Atom processor running Debian unstable.
Sometimes when DPMS switches off the screen the system reboots. More often it
does not reboot but shows a white screen on reactivation. Then I can ssh into
the box from another host but the white screen remains even if I restart X or
change VT. This never seems to happen the first time the screen is switched off,
generally it takes 3 or 4 cycles to trigger the bug. Kernel 3.4.3 works fine.
There are no messages in the logs. Any idea what might cause this or how I
can debug it any further? I will supply more details on my setup if needed.
Please CC me in your reply as I am not subscribed to the list.

Thanks in advance
                 Georg Chini
