Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab1AJTci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:32:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:50224 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208Ab1AJTcf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:32:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,302,1291622400"; 
   d="scan'208";a="372515623"
From: "Heasley, Seth" <seth.heasley@intel.com>
To: Jean Delvare <khali@linux-fr.org>
CC: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Mon, 10 Jan 2011 11:32:32 -0800
Subject: RE: [PATCH 2.6.37] irq: irq and pci_ids patch for Intel DH89xxCC
  DeviceIDs
Thread-Topic: [PATCH 2.6.37] irq: irq and pci_ids patch for Intel DH89xxCC
  DeviceIDs
Thread-Index: Acuw/L45AXJkLlfCR027z1+YXxX+VwAACLnA
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25C1AF90E0@orsmsx501.amr.corp.intel.com>
References: <201101101058.13515.seth.heasley@intel.com>
	<20110110201430.7ab599c4@endymion.delvare>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25C1AF9090@orsmsx501.amr.corp.intel.com>
 <20110110202934.5e4924b8@endymion.delvare>
In-Reply-To: <20110110202934.5e4924b8@endymion.delvare>
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

>> Some products are defining a range of DeviceIDs rather than one or two
>specific IDs, so these blocks are for catching any DeviceID in the
>range.  I'm certainly open to suggestion for a better way to handle
>these, and I agree that the current way is awkward.
>
>I understand the need to have separate blocks for separate IDs and for
>ID ranges. But all the ranges could be covered by the same block:
>
>	if ((device >= PCI_DEVICE_ID_INTEL_5_3400_SERIES_LPC_MIN &&
>	     device <= PCI_DEVICE_ID_INTEL_5_3400_SERIES_LPC_MAX)
>	 || (device >= PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MIN &&
>	     device <= PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX)) {
>		r->name = "PIIX/ICH";
>		r->get = pirq_piix_get;
>		r->set = pirq_piix_set;
>		return 1;
>	}

Not sure why I didn't do it this way.  Thanks for the help!

-Seth
