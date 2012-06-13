Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab2FMXzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 19:55:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:7904 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab2FMXza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 19:55:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="179708994"
From: "Luck, Tony" <tony.luck@intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>, Mike Waychison <mikew@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "rob@landley.net" <rob@landley.net>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][Patch]efi_pstore:Introduce an efi_pstore_overwrite
 parameter to avoid missing messages in NVRAM
Thread-Topic: [RFC][Patch]efi_pstore:Introduce an efi_pstore_overwrite
 parameter to avoid missing messages in NVRAM
Thread-Index: Ac1Jaf3kQfy2nRzQSNG3UORn8S5p+AAc0YIAAA6J6JAAGwBGkAAyPwIgAGROu0AAyB10UAGPtaXA
Date: Wed, 13 Jun 2012 23:55:15 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1930CAE4@ORSMSX103.amr.corp.intel.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2E5A4DB2B8@USINDEVS01.corp.hds.com>
 <CAGTjWtAb3XrsTtkvW=G0YN1RCVxYxcPksSh3jEogeEu4qWqv1Q@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F1930C820@ORSMSX103.amr.corp.intel.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2E5A4DB451@USINDEVS01.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1930CA84@ORSMSX103.amr.corp.intel.com>
 <32727E9A83EE9A42A1F0906295A3A77B2EE701160E@USINDEVS01.corp.hds.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2E5A4DB459@USINDEVS01.corp.hds.com>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2E5A4DB459@USINDEVS01.corp.hds.com>
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

> I have one question. (It is not directly related to a discussion here.)
> Do you mean the limitation is due to EFI specification?
> Or do you mean there is no EFI server capable of a much amount of NVRAM? 

Maybe Matthew can answer that - I wouldn't think that the specification would
limit the amount of NVRAM - but I would expect implementations to do so. Generally
the EFI persistent space has to share the same flash chip as the BIOS ... and the
BIOS folks are good at filling up all the space with their own code & data. These
chips are still only a few (4, 8) Megabytes or so.

-Tony
