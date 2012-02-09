Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab2BIAY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 19:24:59 -0500
Received: from mga14.intel.com ([143.182.124.37]:3708 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558Ab2BIAY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 19:24:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="64636314"
From: "Luck, Tony" <tony.luck@intel.com>
To: Jiri Kosina <jkosina@suse.cz>, "Yu, Fenghua" <fenghua.yu@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Raymund Will <rw@suse.de>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: RE: [PATCH] [IA64] disable interrupts when exiting from
 ia64_mca_cmc_int_handler()
Thread-Topic: [PATCH] [IA64] disable interrupts when exiting from
 ia64_mca_cmc_int_handler()
Thread-Index: AQHM5m52CFtPbkjviUugsD9HEYkwHpYztU2g
Date: Thu, 9 Feb 2012 00:24:49 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F0398CE@ORSMSX104.amr.corp.intel.com>
References: <alpine.LNX.2.00.1202081530510.24127@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1202081530510.24127@pobox.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Disable the interrupts again before exiting. This is analogous to 
> a3967685745 ("[IA64] disable interrupts at end of 
> ia64_mca_cpe_int_handler()").

Thanks. Applied. Should show up in linux-next in a day or two, and
I'll send to Linus in next merge window.

-Tony
