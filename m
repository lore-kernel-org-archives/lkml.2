Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab2AWSYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 13:24:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:25655 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab2AWSYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:24:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="115304086"
From: "Luck, Tony" <tony.luck@intel.com>
To: Thomas Renninger <trenn@suse.de>, Bjorn Helgaas <bhelgaas@google.com>
CC: Myron Stowe <myron.stowe@redhat.com>, "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "Huang, Ying" <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: RE: [PATCH 2/3] ACPI, APEI: Add RAM mapping support to ACPI
Thread-Topic: [PATCH 2/3] ACPI, APEI: Add RAM mapping support to ACPI
Thread-Index: AQHM2eba+IAjO9rYxEyhrzuLyeBxnpYaQ+kA
Date: Mon, 23 Jan 2012 18:23:56 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F0282EE@ORSMSX104.amr.corp.intel.com>
References: <201201231651.23270.trenn@suse.de>
In-Reply-To: <201201231651.23270.trenn@suse.de>
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

> Is there any Itanium out there implementing any APEI table?
> Will there ever be one?

With respect to the EINJ table - the answer is definitely no.
Itanium has a PAL mechanism for injecting errors, so there is
no need to implement EINJ.

-Tony
