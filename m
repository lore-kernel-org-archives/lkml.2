Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031137Ab2CNVxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:53:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:43718 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031036Ab2CNVxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:53:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="138949233"
From: "Luck, Tony" <tony.luck@intel.com>
To: Adalbert Dawid <dawid@rinux.net>
CC: Borislav Petkov <bp@amd64.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "x86@kernel.org" <x86@kernel.org>
Subject: RE: Kernel Panic with Rawtherapee (mce related)
Thread-Topic: Kernel Panic with Rawtherapee (mce related)
Thread-Index: AQHNAfJ8aeq5R/7dC0Geu08XqQtP/ZZqaDgA//+nNZCAAKFdgP//o10g
Date: Wed, 14 Mar 2012 21:53:34 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F15B64D0A@ORSMSX103.amr.corp.intel.com>
References: <1331678930.11814.16.camel@erde.fritz.box>
	 <4F60B0E3.6020503@linux.vnet.ibm.com> <20120314155906.GA25286@aftab>
	 <3908561D78D1C84285E8C5FCA982C28F15B64BF0@ORSMSX103.amr.corp.intel.com>
 <1331756331.5315.19.camel@erde.fritz.box>
In-Reply-To: <1331756331.5315.19.camel@erde.fritz.box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2ELrmXo031277

> It would be very helpful to disable the "reboot in 30 seconds" timeout.
> Is that possible somehow?

# echo 0 > /proc/sys/kernel/panic

[A non-zero value is the number of seconds before rebooting. zero means don't reboot]

> Up to now, it has always been rawtherapee that crashed the machine. This
> is why I thought it might possibly be some special cpu feature (an SSE
> command or something) that happens to be broken in my cpu and that is
> triggered only by rawtherapee and not by any other software. What is
> your opinion on this theory?

Can you set up a serial console for this system?  Seeing the kernel
log leading up to the machine checks might also give some clues (e.g.
perhaps rawtherapee is running the system out of memory right before
the crash).

-Tony

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
