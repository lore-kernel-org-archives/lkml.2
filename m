Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab2JJBeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 21:34:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:48786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757243Ab2JJBeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 21:34:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,562,1344236400"; 
   d="scan'208";a="203679192"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: "Brown, Len" <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        "Tang, Feng" <feng.tang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: RE: [PATCH v5 2/2] ACPI: Add Intel MID SPI early console support.
Thread-Topic: [PATCH v5 2/2] ACPI: Add Intel MID SPI early console support.
Thread-Index: AQHNpccWOsRN38H3PkiZ0OPD7qJtmJewrxwAgAETi3A=
Date: Wed, 10 Oct 2012 01:33:51 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88B9C9D2@SHSMSX101.ccr.corp.intel.com>
References: <cover.1347453194.git.zetalog@gmail.com>
 <534b1bf9fba2b51bdff554e100931713dd7da2a9.1349749925.git.lv.zheng@intel.com>
 <20121009170613.GF25276@phenom.dumpdata.com>
In-Reply-To: <20121009170613.GF25276@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >   earlyprintk=acpi
> .. or earlyprintk=mrst
> ?

ACK.
The two launchers are all workable for MID_SPI.  I'll add more comments and resend this patch.  Thanks

