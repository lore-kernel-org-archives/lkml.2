Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab3ADWWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 17:22:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:44639 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749Ab3ADWWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 17:22:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,412,1355126400"; 
   d="scan'208";a="187836138"
From: "Luck, Tony" <tony.luck@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Lance Ortiz <lance.ortiz@hp.com>
CC: "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v9 3/3] aerdrv: Cleanup log output for AER
Thread-Topic: [PATCH v9 3/3] aerdrv: Cleanup log output for AER
Thread-Index: AQHN6frIwd9UuPay0k62xJs9cHg035g6Qe0A//98gUA=
Date: Fri, 4 Jan 2013 22:22:09 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1C9750EE@ORSMSX108.amr.corp.intel.com>
References: <20130103223401.10751.1838.stgit@grignak.americas.hpqcorp.net>
 <20130103223415.10751.17744.stgit@grignak.americas.hpqcorp.net>
 <CAErSpo5LV5QApKqVVV7FdpjdFFZ9=+8JJfaDtDqJ2AzFpxM+HA@mail.gmail.com>
In-Reply-To: <CAErSpo5LV5QApKqVVV7FdpjdFFZ9=+8JJfaDtDqJ2AzFpxM+HA@mail.gmail.com>
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

I sent a "please pull" to Ingo/Peter/Thomas about an hour ago ... if they
push back (or ignore) we can fold your ack and nit-picks into another
version.

> s/elimiating/eliminating/ above.
Ugh ... nobody spotted this one ("many eyes" really does work!)

> I remove the "v1-v2" notes when I merge patches because I don't think
> they're useful any more.  But if Tony applies these, he can use his
> judgment.

Yes - I do too.  In fact it is easier on the maintainer if this sort of meta-commentary
goes *after* the "---" in the patch. Then it is available for review (where it is
most helpful), but tools will automatically drop it when applying the patch.

-Tony
