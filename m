Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab2DWQYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:24:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:14836 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab2DWQYC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:24:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="92150009"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "Liu, Jinsong" <jinsong.liu@intel.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
Thread-Topic: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
Thread-Index: AQHNH3YMj31i2PR/lkqeiia+nqwVVJaljggAgAKXIICAAECDgIAAljWAgAAOzoD//4+fQA==
Date: Mon, 23 Apr 2012 16:23:59 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F170EF92E@ORSMSX104.amr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com>
 <20120421041454.GA29704@phenom.dumpdata.com>
 <20120421104502.GB17005@aftab.osrc.amd.com>
 <20120423021827.GA13840@phenom.dumpdata.com>
 <20120423060921.GA29378@aftab.osrc.amd.com>
 <20120423150657.GA24481@phenom.dumpdata.com>
 <20120423155957.GA6147@aftab.osrc.amd.com>
In-Reply-To: <20120423155957.GA6147@aftab.osrc.amd.com>
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

> Perfect. Software is more elastic than hardware - so the Xen ABI
> for the MCE can be changed then to reflect the new format if required.

To developers working upstream in open source projects ... yes, software
does look like it is easy to change.  But in the long term software is
very difficult to change. Enterprise versions for Linux now come with
up to ten years of support ... and they are expected to be updated with
support for new hardware for much of their support lifetime. So what goes
into upstream now will be a support burden for somebody until around 2022.

So please look at the suggestions that Boris has provided, and think about
if there is a cleaner, more maintainable way to pass error data around.

-Tony
