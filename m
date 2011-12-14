Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab1LNWRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 17:17:19 -0500
Received: from incomingmail.riverbed.com ([208.70.196.45]:27958 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab1LNWRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 17:17:16 -0500
From: Jiang Wang <Jiang.Wang@riverbed.com>
To: Ben Hutchings <bhutchings@solarflare.com>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Prasanna Panchamukhi <Prasanna.Panchamukhi@riverbed.com>,
        Chaitanya Lala <Chaitanya.Lala@riverbed.com>,
        "Francis St. Amant" <Francis.St.Amant@riverbed.com>,
        "miles.ito@intel.com" <miles.ito@intel.com>
Subject: RE: [PATCH 1/2] e100: power down PHY if WOL is not enabled
Thread-Topic: [PATCH 1/2] e100: power down PHY if WOL is not enabled
Thread-Index: AQHMupWw3KBVkwNve0CC+hQ7t8HMcZXcT2kA//+RlTCAAImTAP//fCUg
Date: Wed, 14 Dec 2011 22:16:54 +0000
Message-ID: <CEE05A0D7856E14880AD5560634EBEA82AA78752@365EXCH-MBX-P5.nbttech.com>
References: <1323830996-16388-1-git-send-email-Jiang.Wang@riverbed.com>
	 <1323894636.2753.2.camel@bwh-desktop>
	 <CEE05A0D7856E14880AD5560634EBEA82AA78720@365EXCH-MBX-P5.nbttech.com>
 <1323900468.2753.22.camel@bwh-desktop>
In-Reply-To: <1323900468.2753.22.camel@bwh-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.205.252]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBEMHRCg005059

I see. I will add one more check for that. Thanks.

-------------------------------------
Jiang Wang
Member of Technical Staff
Riverbed Technology
Tel: (408) 522-5109
Email: Jiang.Wang@riverbed.com
www.riverbed.com


-----Original Message-----
From: Ben Hutchings [mailto:bhutchings@solarflare.com] 
Sent: Wednesday, December 14, 2011 2:08 PM
To: Jiang Wang
Cc: Jeff Kirsher; Jesse Brandeburg; Bruce Allan; Carolyn Wyborny; Don Skidmore; Greg Rose; Peter P Waskiewicz Jr; Alex Duyck; John Ronciak; e1000-devel@lists.sourceforge.net; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Prasanna Panchamukhi; Chaitanya Lala; Francis St. Amant; miles.ito@intel.com
Subject: RE: [PATCH 1/2] e100: power down PHY if WOL is not enabled

On Wed, 2011-12-14 at 21:59 +0000, Jiang Wang wrote:
> Hi Ben,
> 
> Do you mean the WOL is enabled but PHY is powered off somehow? That 
> scenario should never happen. If WOL is enabled, there is no code to 
> power off PHY.
[...]

Initial conditions: interface up, WOL off, PHY on.

1. Bring interface down. PHY is turned off.
2. Turn WOL on.  PHY is still off, but needs to be on.

Ben.

--
Ben Hutchings, Staff Engineer, Solarflare Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
