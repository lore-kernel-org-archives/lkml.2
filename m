Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab0HMWd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 18:33:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:53216 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452Ab0HMWd6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 18:33:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,365,1278313200"; 
   d="scan'208";a="596235458"
From: "Luck, Tony" <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Takao Indoh <indou.takao@jp.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>
Date: Fri, 13 Aug 2010 15:33:56 -0700
Subject: RE: [PATCH][EFI] Run EFI in physical mode
Thread-Topic: [PATCH][EFI] Run EFI in physical mode
Thread-Index: Acs7NlxR9csZhCOhRcOLIAMflAoXWwAANWbg
Message-ID: <987664A83D2D224EAE907B061CE93D53015B2DAD87@orsmsx505.amr.corp.intel.com>
References: <F0CB3B1C601247indou.takao@jp.fujitsu.com>
 <4C65C630.4070008@zytor.com>
In-Reply-To: <4C65C630.4070008@zytor.com>
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

> does this affect ia64 in any way?

I remember Eric complaining that set_virtual_address_map() was a one
way trap door with no way to get back to physical mode ... and thus
this was a big problem to support kexec on ia64. And yet we still call
it, and ia64 can do kexec. So some other work around must have been
found. Can't immediately remember what it was though.

-Tony
