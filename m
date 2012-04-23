Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab2DWQRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:17:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:33373 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab2DWQRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:17:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="157154835"
From: "Luck, Tony" <tony.luck@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Borislav Petkov <bp@amd64.org>, "Liu, Jinsong" <jinsong.liu@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
Thread-Topic: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
Thread-Index: AQHNH3YMj31i2PR/lkqeiia+nqwVVJaljggAgAL9hUCAAHdtAP//ln5w
Date: Mon, 23 Apr 2012 16:17:14 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F170EF914@ORSMSX104.amr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com>
 <20120421041454.GA29704@phenom.dumpdata.com>
 <20120421104502.GB17005@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F170EF841@ORSMSX104.amr.corp.intel.com>
 <20120423153222.GE24481@phenom.dumpdata.com>
In-Reply-To: <20120423153222.GE24481@phenom.dumpdata.com>
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

> This driver is _not_ doing a strict bit-by-bit copy of 'struct mcinfo'
> to 'struct mce'. It is plucking the right bits and setting them in
> 'struct mce'.

That isn't any worse that what we currently have ... but what we currently
have is ugly, and doing more ugly things just because we did them before
generally isn't a winning argument on the mailing lists.

-Tony
