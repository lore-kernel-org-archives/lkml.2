Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab2DWWTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:19:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:55030 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab2DWWTi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:19:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="92269243"
From: "Heasley, Seth" <seth.heasley@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ralston, James D" <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: RE: [PATCH 1/3] pci_ids: Add Intel Centerton Legacy Block DeviceID
Thread-Topic: [PATCH 1/3] pci_ids: Add Intel Centerton Legacy Block DeviceID
Thread-Index: AQHNIW3wmSJT5D2VNEeBlrnlFN5oW5apcFuA//+K5FA=
Date: Mon, 23 Apr 2012 22:19:36 +0000
Message-ID: <DEC3922D1904474A8862C7BFF516EA9A41A67C33@ORSMSX101.amr.corp.intel.com>
References: <1335198236-3183-1-git-send-email-seth.heasley@intel.com>
 <CAErSpo5XN2f-Xg6QgkqQDr-UBOLg2aQ6ZuhrCGv6KMxSat6=Tw@mail.gmail.com>
In-Reply-To: <CAErSpo5XN2f-Xg6QgkqQDr-UBOLg2aQ6ZuhrCGv6KMxSat6=Tw@mail.gmail.com>
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

>I assume, based on your LKML exchange with Samuel, that you don't need
>me to do anything in PCI with this.

I believe that's right.  Samuel figured that since the patch I sent him depends on this one, that he'd go ahead and commit the pciids patch, too.

-Seth
