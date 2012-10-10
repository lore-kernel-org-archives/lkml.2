Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab2JJBkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 21:40:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:35554 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238Ab2JJBkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 21:40:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,562,1344236400"; 
   d="scan'208";a="203682142"
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
Subject: RE: [PATCH v5 1/2] ACPI: Add early console framework for DBGP/DBG2.
Thread-Topic: [PATCH v5 1/2] ACPI: Add early console framework for DBGP/DBG2.
Thread-Index: AQHNpccPIkmRrmh9DEqFt+BQNxKiaJewrgcAgAEWBLA=
Date: Wed, 10 Oct 2012 01:40:00 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88B9C9E2@SHSMSX101.ccr.corp.intel.com>
References: <cover.1347453194.git.zetalog@gmail.com>
 <6a6a79654294bf4a3a9df1cf81880a44aeea4b44.1349749925.git.lv.zheng@intel.com>
 <20121009170220.GE25276@phenom.dumpdata.com>
In-Reply-To: <20121009170220.GE25276@phenom.dumpdata.com>
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

> > +int __init acpi_early_console_keep(struct acpi_debug_port *info)
> 
> Why not make it 'bool' like the other (acpi_early_console_enabled)?

NAK.
"keep" is "int" in "setup_early_printk".

Best regards/Lv Zheng
