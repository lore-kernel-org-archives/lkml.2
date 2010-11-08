Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab0KHWBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:01:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:3233 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab0KHWBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:01:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,171,1288594800"; 
   d="scan'208";a="855448320"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: Andi Kleen <andi@firstfloor.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Date: Mon, 8 Nov 2010 22:01:11 +0000
Subject: RE: [PATCH] iwl3945: Fix oops at module load
Thread-Topic: [PATCH] iwl3945: Fix oops at module load
Thread-Index: Act/j5ABPPhKV6aKRH2UWQCPdnfX6gAAL1kA
Message-ID: <C5C86A19469DAE48AAAD0E5F3716E44501D40EE169@irsmsx504.ger.corp.intel.com>
References: <1289253271-19981-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1289253271-19981-1-git-send-email-andi@firstfloor.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andi Kleen <ak@linux.intel.com>
> 
> On my laptop the iwl3945 driver oopsed at boot with 2.6.37-rc1
> in __dev_printk.
> 
> The problem is that for some reason it prints the sw scan
> warning, but does that before the pci device is initialized
> in the driver private structure. This leads to an oops
> in the warning print code.
> 
> Move the warning after the device has been initialized.

Yup, something like this is needed, sorry about this!
I believe we have a fix for this in the pipeline somewhere.

johannes
--------------------------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland 
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052

