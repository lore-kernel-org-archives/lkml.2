Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab2GXT6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 15:58:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:29344 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397Ab2GXT57 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 15:57:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="185273831"
From: "Luck, Tony" <tony.luck@intel.com>
To: Matthew Garrett <mjg@redhat.com>
CC: Seiji Aguchi <seiji.aguchi@hds.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
Subject: RE: [RFC][PATCH v2 2/3] Hold multiple logs
Thread-Topic: [RFC][PATCH v2 2/3] Hold multiple logs
Thread-Index: Ac1l82ceH7I0t1QCT1GombsnNxviZAAAK4PgAABTBVAAAP4IQAAA0SRAAAJWEXAAAc9d8AAUbUAAAK5hfwAAONBtAAAN3tpg//+gaQCAAFnGIA==
Date: Tue, 24 Jul 2012 19:57:52 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19370CA2@ORSMSX104.amr.corp.intel.com>
References: <3908561D78D1C84285E8C5FCA982C28F1936EA5F@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB28056@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EA97@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB2813D@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EADE@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB28206@USINDEM103.corp.hds.com>
 <20120720030328.GC5637@redhat.com> <20120723141632.GB23047@srcf.ucam.org>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB33479@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F19370A1B@ORSMSX104.amr.corp.intel.com>
 <20120724181820.GA23820@srcf.ucam.org>
In-Reply-To: <20120724181820.GA23820@srcf.ucam.org>
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

> One thing that's worth noting - UEFI systems will typically only recover 
> deleted space on reset. create->delete->create->delete will reduce 
> available space until the platform is rebooted, at which point the 
> deleted portion will become available again.

Some ACPI/ERST systems do this too :-(

-Tony
