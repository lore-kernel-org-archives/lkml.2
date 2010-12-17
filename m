Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab0LQT6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:58:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:60841 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576Ab0LQT6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:58:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,189,1291622400"; 
   d="scan'208";a="688268737"
From: "Luck, Tony" <tony.luck@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 17 Dec 2010 11:58:27 -0800
Subject: RE: linux-next: build warnings after merge of the ia64 tree
Thread-Topic: linux-next: build warnings after merge of the ia64 tree
Thread-Index: AcudhbR5K7HiBpIwQcidUnOien9I4gAnsUsQ
Message-ID: <987664A83D2D224EAE907B061CE93D530193D00F91@orsmsx505.amr.corp.intel.com>
References: <20101217112357.ec7879f1.sfr@canb.auug.org.au>
	<987664A83D2D224EAE907B061CE93D530193D00A15@orsmsx505.amr.corp.intel.com>
 <20101217115932.a633519e.sfr@canb.auug.org.au>
In-Reply-To: <20101217115932.a633519e.sfr@canb.auug.org.au>
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

>> commit 3b38bb5f7f06356a89bb2cbf92ad346025e95192
>> Author: Huang Ying <ying.huang@intel.com>
>> Date:   Thu Dec 2 10:40:53 2010 +0800
>> 
>>     ACPI, APEI, use raw spinlock in ERST
>
> That commit is in Linus' tree as of v2.6.37-rc6 so if you merge -rc6 into
> your tree, you can fix the conflict there.

Ah good. I've rebased a new version of my code on top of -rc6.

Thanks

-Tony
