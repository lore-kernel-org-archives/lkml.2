Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab2GHAfq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 20:35:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:61168 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab2GHAfo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 20:35:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="189705304"
From: "Boie, Andrew P" <andrew.p.boie@intel.com>
To: Colin Cross <ccross@android.com>
CC: Greg KH <gregkh@linuxfoundation.org>, NeilBrown <neilb@suse.de>,
        "arve@android.com" <arve@android.com>,
        "rebecca@android.com" <rebecca@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcb: Android bootloader control block driver
Thread-Topic: [PATCH] bcb: Android bootloader control block driver
Thread-Index: AQHNVi6IYvF8HUl+QUidlx/DSCdfp5cSqHCAgAAFlwCAAAoIAIAABREAgALaKoCACVRWgIAAB3uAgAAWPYD//42AEA==
Date: Sun, 8 Jul 2012 00:35:42 +0000
Message-ID: <574B04EC-D2C0-4AD9-897E-1F9AB6A7B1E7@intel.com>
References: <1340998590-23042-1-git-send-email-andrew.p.boie@intel.com>
	<20120630032333.GB3972@kroah.com>
	<CAMbhsRSYL3oE_mbdjyNbV453DddPNUyJBU2eLJhUNaASF1+MtA@mail.gmail.com>
	<20120630041928.GA1816@kroah.com>
	<CAMbhsRRUs1tHQ+DfWzhKE6M47+Rqu0uB4hQgX7d7ZGzaZi9uyw@mail.gmail.com>
	<20120702101057.2a8dd6a6@notabene.brown>
	<CAMbhsRSQhBTxA9g1b4Pc6px4gYcOzn4miOrS6ecdJmOQ+RNSGA@mail.gmail.com>
	<20120707230555.GA29514@kroah.com>,<CAMbhsRSy+cYRDjmYtMdHNUSK4y+vSoEHgKNCaLvvNVopnSvh-Q@mail.gmail.com>
In-Reply-To: <CAMbhsRSy+cYRDjmYtMdHNUSK4y+vSoEHgKNCaLvvNVopnSvh-Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Other boards (don't have a specific example here, perhaps Andrew can
> provide one) need to store the reboot reason on disk.

For this case, I'm trying to get the alternate boot logic to work on PC compatible devices. I have a patch against SYSLINUX which reads this area and selects an alternate boot target appropriately.

Andrew