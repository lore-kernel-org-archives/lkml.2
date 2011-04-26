Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab1DZXeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 19:34:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:46104 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954Ab1DZXeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 19:34:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,271,1301900400"; 
   d="scan'208";a="738886496"
From: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
To: Maximilian Engelhardt <maxi@daemonizer.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        StuStaNet Vorstand <vorstand@stusta.mhn.de>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Date: Tue, 26 Apr 2011 16:34:09 -0700
Subject: RE: Kernel crash after using new Intel NIC (igb)
Thread-Topic: Kernel crash after using new Intel NIC (igb)
Thread-Index: AcwC0NXTQ7OJQ7B+SPKDTk15EuQJJwBmOnkQ
Message-ID: <EDC0E76513226749BFBC9C3FB031318F016B4125A4@orsmsx508.amr.corp.intel.com>
References: <201104250033.03401.maxi@daemonizer.de>
In-Reply-To: <201104250033.03401.maxi@daemonizer.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3QNYPi7021781



>-----Original Message-----
>From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
>On Behalf Of Maximilian Engelhardt
>Sent: Sunday, April 24, 2011 3:33 PM
>To: linux-kernel@vger.kernel.org
>Cc: netdev@vger.kernel.org; StuStaNet Vorstand
>Subject: Kernel crash after using new Intel NIC (igb)
>
>Hello,
>
>some time ago we switched some of our servers to a new networking card
>that
>uses the Intel igb driver. Since that time we see regular kernel
>crashes.
>The crashes happen at very irregular intervals, sometimes after a week
>uptime,
>sometimes after a month or even more. They seem to be independent of the
>server load as they also happen in the night when there is low traffic.
>
>The affected server is used as a NAT device with some iptables rules and
>serves
>about 2000 people.
>
>Attached are two logs of the crashes as well as the output of dmesg,
>lspci,
>and /proc/interrupts as well as the used kernel config.
>
>I have no idea what might be wrong but I think it is a kernel bug.
>Perhaps
>someone with more knowledge has a clue.
>
>If needed I can provide additional information or build different
>kernels.
>
>Greetings,
>Maxi

Hello,

I'm sorry you're having crashes since installing our NIC.  Thank you for the data.  I haven't had a chance to review it carefully yet, but it looks to me like the crashes have us in the stack sometimes and sometimes not.  I need to do a bit more research and will need some more information.  Can I get an ethtool -i eth# for the device and also lspci -vvv for the platform its installed on.

If you open an issue at SourceForge we will have a place to keep the logs.

I will research this a bit more and get back to you tomorrow my time.

Thanks,

Carolyn
Carolyn Wyborny
Linux Development
LAN Access Division
Intel Corporation




ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
