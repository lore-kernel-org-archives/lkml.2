Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260Ab1LNWH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 17:07:56 -0500
Received: from mail.solarflare.com ([216.237.3.220]:42124 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758231Ab1LNWHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 17:07:54 -0500
Subject: RE: [PATCH 1/2] e100: power down PHY if WOL is not enabled
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jiang Wang <Jiang.Wang@riverbed.com>
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
In-Reply-To: <CEE05A0D7856E14880AD5560634EBEA82AA78720@365EXCH-MBX-P5.nbttech.com>
References: <1323830996-16388-1-git-send-email-Jiang.Wang@riverbed.com>
	 <1323894636.2753.2.camel@bwh-desktop>
	 <CEE05A0D7856E14880AD5560634EBEA82AA78720@365EXCH-MBX-P5.nbttech.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Wed, 14 Dec 2011 22:07:48 +0000
Message-ID: <1323900468.2753.22.camel@bwh-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18580.005
X-TM-AS-Result: No--7.490100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

