Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab2GXVMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 17:12:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:47034 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067Ab2GXVM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 17:12:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="176982016"
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
Thread-Index: Ac1l82ceH7I0t1QCT1GombsnNxviZAAAK4PgAABTBVAAAP4IQAAA0SRAAAJWEXAAAc9d8AAUbUAAAK5hfwAAONBtAAAN3tpg//+gaQCAAFnGIP//zcaAgABzfqD//5Q0gIAAdN/Q
Date: Tue, 24 Jul 2012 21:12:25 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19370D52@ORSMSX104.amr.corp.intel.com>
References: <3908561D78D1C84285E8C5FCA982C28F1936EADE@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB28206@USINDEM103.corp.hds.com>
 <20120720030328.GC5637@redhat.com> <20120723141632.GB23047@srcf.ucam.org>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB33479@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F19370A1B@ORSMSX104.amr.corp.intel.com>
 <20120724181820.GA23820@srcf.ucam.org>
 <3908561D78D1C84285E8C5FCA982C28F19370CA2@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB346A4@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F19370D21@ORSMSX104.amr.corp.intel.com>
 <20120724210725.GA29109@srcf.ucam.org>
In-Reply-To: <20120724210725.GA29109@srcf.ucam.org>
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

> I think we inevitably lose in that scenario. I'd need to verify, but my 
> recollection is that overwriting existing variables may be equivalent to 
> a delete/create cycle.

This would mean that EFI really wants the OS to treat EFI variables as pretty much
exclusively read-only.  Any activity which periodically updates a variable would
eventually run into problems in an EFI implementation that loses the old space
until a reset.

Sad.

-Tony
