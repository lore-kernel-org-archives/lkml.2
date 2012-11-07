Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2KGQw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:52:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:8003 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab2KGQwz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:52:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,730,1344236400"; 
   d="scan'208";a="216385186"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <jbeulich@suse.com>
Subject: RE: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Topic: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Index: AQHNvQFcTi91BiFLfUibRvXA4zlK85felYuw
Date: Wed, 7 Nov 2012 16:52:50 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233537BB2F@SHSMSX101.ccr.corp.intel.com>
References: <20121026201409.GF2708@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC8292335377346@SHSMSX101.ccr.corp.intel.com>
 <20121102164937.GC27213@konrad-lan.dumpdata.com>
 <alpine.DEB.2.02.1211051512260.2689@kaball.uk.xensource.com>
 <DE8DF0795D48FD4CA783C40EC829233537B10C@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233537B147@SHSMSX101.ccr.corp.intel.com>
 <alpine.DEB.2.02.1211061455150.2689@kaball.uk.xensource.com>
 <DE8DF0795D48FD4CA783C40EC829233537B479@SHSMSX101.ccr.corp.intel.com>
 <20121106164303.GO9966@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC829233537B99E@SHSMSX101.ccr.corp.intel.com>
 <20121107160301.GF18615@phenom.dumpdata.com>
In-Reply-To: <20121107160301.GF18615@phenom.dumpdata.com>
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

Konrad Rzeszutek Wilk wrote:
> On Wed, Nov 07, 2012 at 12:58:19PM +0000, Liu, Jinsong wrote:
>>>>> 
>>>>> If it is generic ACPI code, than it can depend only on ACPI.
>>>>> If it is ACPI code that contains X86 specific info, than it needs
>>>>> to depend on X86 too.
>>>> 
>>>> No x86 specific so let's depend on ACPI.
>>> 
>>> Huh? This feature is x86 specific isn't it? I mean it is in the ACPI
>>> spec, but only x86 does it right?
>> 
>> OK, updated w/ ACPI & X86 dependency, and per other comments.
> 
> Ok. Could you send all the patchset in one go. I am bit lost of which
> one to review as none of them seem to have the version information
> [vX: Did this yyy]

Not quite clear your meaning, do you mean not reply old email and start a new thread with title like
[PATCH vX 1/2]: xen/acpi: ACPI PAD driver
[PATCH vX 2/2]: ...
?

> 
> right above your name or in the title:
> [PATCH vX 1/2]: yyyy
> 
> anyhow, some comments below.
> 

OK.

Thanks,
Jinsong
