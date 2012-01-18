Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab2ARTA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 14:00:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:13559 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924Ab2ARTAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 14:00:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108404802"
From: "Luck, Tony" <tony.luck@intel.com>
To: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Sergei Trofimovich <slyich@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "prasad@linux.vnet.ibm.com" <prasad@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>,
        "gouders@et.bocholt.fh-gelsenkirchen.de" 
	<gouders@et.bocholt.fh-gelsenkirchen.de>,
        Marcos Souza <marcos.mage@gmail.com>,
        "justinmattock@gmail.com" <justinmattock@gmail.com>,
        Jeff Chua <jeff.chua.linux@gmail.com>
Subject: RE: [PATCH] mce: fix warning messages about static struct mce_device
Thread-Topic: [PATCH] mce: fix warning messages about static struct
 mce_device
Thread-Index: AQHM1J/gZZi9VvM99kKJ1R/CbZ8vIpYQw7OAgAB45YCAASg4AIAAVvMAgAATRoD//5B5gIAAlmeAgAALAQD//3xOIA==
Date: Wed, 18 Jan 2012 19:00:22 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F01CF83@ORSMSX104.amr.corp.intel.com>
References: <3908561D78D1C84285E8C5FCA982C28F01CF24@ORSMSX104.amr.corp.intel.com>
 <Pine.LNX.4.44L0.1201181257540.1343-100000@iolanthe.rowland.org>
 <CAPXgP10Du4nJ_hdfwqV0Fr6XEVkTMO6jZ_TS_T-J-grDG7nKJw@mail.gmail.com>
In-Reply-To: <CAPXgP10Du4nJ_hdfwqV0Fr6XEVkTMO6jZ_TS_T-J-grDG7nKJw@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0IJ0YQ2026127

> This way, the new object is full functional, does not conflict with
> the older one, and also all the users of the old memory are still fine
> and can cleanup a lazy as they need without much synchronization.

Thanks Alan & Kay ... makes sense to me now.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
