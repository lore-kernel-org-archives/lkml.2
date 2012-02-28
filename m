Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab2B1AWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:22:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:5164 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125Ab2B1AWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:22:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="115451612"
From: "Luck, Tony" <tony.luck@intel.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "jes@trained-monkey.org" <jes@trained-monkey.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
CC: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ia64: fix a couple of warnings for EXPORT_SYMBOL
Thread-Topic: [PATCH] ia64: fix a couple of warnings for EXPORT_SYMBOL
Thread-Index: AQHM9aS9ulcYoyPXtkiU0eJJ2jwnwpZRcSrA
Date: Tue, 28 Feb 2012 00:18:05 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F03F633@ORSMSX104.amr.corp.intel.com>
References: <1330384105-27794-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1330384105-27794-1-git-send-email-paul.gortmaker@windriver.com>
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

[I can carry this patch if required, but it is 100% independent and
 can go in via the ia64 maintainers.  Let me know which is best. ]

I'll take it into the ia64 tree (already grabbed the machine_kexec.c
and tiocx.c patches you posted earlier).

-Tony
