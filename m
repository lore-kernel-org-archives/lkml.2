Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab2LRAcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 19:32:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:58488 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253Ab2LRAcO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 19:32:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,305,1355126400"; 
   d="scan'208";a="232877699"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH v3 08/10] x86/head64.c: Early update ucode in 64-bit
Thread-Topic: [PATCH v3 08/10] x86/head64.c: Early update ucode in 64-bit
Thread-Index: AQHN27U5Cxm9cfLkVkqEiPpUYGHzQJgcPMCAgAA+0YCAAB9DAP//gCswgACSdoCAAPdAkIAAiAKA//+JDSA=
Date: Tue, 18 Dec 2012 00:32:12 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C71220470F859C@ORSMSX105.amr.corp.intel.com>
References: <1355654609-16800-1-git-send-email-fenghua.yu@intel.com>
	<1355654609-16800-9-git-send-email-fenghua.yu@intel.com>
	<CAE9FiQWFRMpxQTTbS+p21EjBvmetup75zD6ipc3COZg7=KyNig@mail.gmail.com>
	<50CE4097.2020104@zytor.com>
	<CAE9FiQXmz07SUEwJdr0QD8Y2Uro6Sizkeg4KfFkJSuQLFW3Fow@mail.gmail.com>
	<3E5A0FA7E9CA944F9D5414FEC6C71220470F81EE@ORSMSX105.amr.corp.intel.com>
	<CAE9FiQUqJVJ6JSeGzFH+OtRA4syrbXZh-RJLSghvB8fdBt97oQ@mail.gmail.com>
	<3E5A0FA7E9CA944F9D5414FEC6C71220470F8584@ORSMSX105.amr.corp.intel.com>
 <CAE9FiQVQMumUSgJ91rT5Zr2_Q=Wk=jBy+MEA3Li0Y215OHQT_Q@mail.gmail.com>
In-Reply-To: <CAE9FiQVQMumUSgJ91rT5Zr2_Q=Wk=jBy+MEA3Li0Y215OHQT_Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> it has to be after #PF handler set page table patch...
> 
> otherwise when ramdisk is above 1G, customer will get early PF
> exception.

In old kernel, where can I put load_ucode_bsp()? Is calling load_ucode_bsp() after relocate_initrd() earliest place?

Thanks.

-Fenghua
