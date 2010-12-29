Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab0L2Cc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 21:32:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:9770 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab0L2Cc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 21:32:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,242,1291622400"; 
   d="scan'208";a="872611024"
From: "Zheng, Shaohui" <shaohui.zheng@intel.com>
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        Andi Kleen <ak@linux.intel.com>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Li, Haicheng" <haicheng.li@intel.com>
Date: Wed, 29 Dec 2010 10:31:13 +0800
Subject: RE: [3/7, v9] NUMA Hotplug Emulator: Add node hotplug emulation
Thread-Topic: [3/7, v9] NUMA Hotplug Emulator: Add node hotplug emulation
Thread-Index: AcumYbqHW9NXYsiHRHqgOoc5ZiGjYAAnki1g
Message-ID: <A24AE1FFE7AEC5489F83450EE98351BF2AEA91755F@shsmsx502.ccr.corp.intel.com>
References: <20101210073119.156388875@intel.com>
 <20101210073242.462037866@intel.com>
 <20101222162723.72075372.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1012272241200.23315@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1012272241200.23315@chino.kir.corp.google.com>
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


> -----Original Message-----
> From: David Rientjes [mailto:rientjes@google.com]
> Sent: Tuesday, December 28, 2010 3:35 PM
> To: Zheng, Shaohui; Andrew Morton
> Cc: linux-mm@kvack.org; linux-kernel@vger.kernel.org; haicheng.li@linux.intel.com; lethal@linux-sh.org; Andi Kleen;
> dave@linux.vnet.ibm.com; Greg Kroah-Hartman; Li, Haicheng
> Subject: Re: [3/7, v9] NUMA Hotplug Emulator: Add node hotplug emulation
> 
> 
> Shaohui, I'll reply to this message with an updated version of this patch
> to address Andrew's comments.  You can merge it into your series or Andrew
> can take it seperately (although it doesn't do much good without "x86: add
> numa=possible command line option" unless you have hotpluggable SRAT
> entries and CONFIG_ACPI_NUMA).


Okay, thanks David. I will merge it into my series when I send next version.

Thanks & Regards,
Shaohui
