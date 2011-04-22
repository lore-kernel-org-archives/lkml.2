Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab1DVQrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:47:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:39073 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211Ab1DVQrg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:47:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,254,1301900400"; 
   d="scan'208";a="632717892"
From: "Heasley, Seth" <seth.heasley@intel.com>
To: Jean Delvare <khali@linux-fr.org>
CC: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Fri, 22 Apr 2011 09:47:34 -0700
Subject: RE: [PATCH 2.6.39-rc3] i2c-i801: SMBus patch for Intel Panther
 Point DeviceIDs
Thread-Topic: [PATCH 2.6.39-rc3] i2c-i801: SMBus patch for Intel Panther
 Point DeviceIDs
Thread-Index: AcwBDJ+9/ounUJHQRde9Y/CVdORnxwAABnBQ
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DCDE2DBA@orsmsx501.amr.corp.intel.com>
References: <201104201133.39979.seth.heasley@intel.com>
 <20110422184449.06116327@endymion.delvare>
In-Reply-To: <20110422184449.06116327@endymion.delvare>
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

Hi Jean,

>With each new chip, we have to add the SMBus device ID to pci_ids.h,
>then wait for Jesse to merge that, and only then I can apply the
>changes to i2c-i801.c. This approach slows things down needlessly.
>
>It isn't mandatory to add IDs to pci_ids.h when an ID is only used
>locally in a device driver. So what I would like to propose is that we
>move all PCI_DEVICE_ID_INTEL_*_SMBUS declarations from pci_ids.h to
>i2c-i801.c now. Then you can resubmit your Panther Point patches, and
>the pci and i2c parts will be independent, so Jesse and myself don't
>depend on each other to apply them.
>
>Seth, if you agree, I can take care of the move, or you can send a
>patch doing that, whatever you prefer.

I've been thinking about this one myself, and I tend to agree.  It'd probably be simpler if you went ahead and made the changes, and I'll be happy to review them.

-Seth
