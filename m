Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729Ab2JJDLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 23:11:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:16730 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab2JJDLD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 23:11:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,563,1344236400"; 
   d="scan'208";a="154434843"
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
Thread-Index: AQHNpccWOsRN38H3PkiZ0OPD7qJtmJewrxwAgAEtzGA=
Date: Wed, 10 Oct 2012 03:10:53 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88B9CA24@SHSMSX101.ccr.corp.intel.com>
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

> > +#ifdef CONFIG_EARLY_PRINTK_INTEL_MID_SPI
> > +	if (info->port_type == ACPI_DBG2_SERIAL_PORT
> > +	    && info->port_subtype == ACPI_DBG2_INTEL_MID_SPI
> > +	    && info->register_count > 0) {
> Is it ever going to be zero?

NAK.
No register base definition (buggy BIOS?) is meaningless for ACPI launched MID_SPI earlycon.

Thanks and best regards/Lv Zheng
