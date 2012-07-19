Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab2GSVXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 17:23:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:1079 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab2GSVX3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 17:23:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="170556972"
From: "Luck, Tony" <tony.luck@intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH v2 2/3] Hold multiple logs
Thread-Topic: [RFC][PATCH v2 2/3] Hold multiple logs
Thread-Index: Ac1l82ceH7I0t1QCT1GombsnNxviZAAAK4Pg
Date: Thu, 19 Jul 2012 21:22:56 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1936EA5F@ORSMSX104.amr.corp.intel.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB27FDC@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB27FDC@USINDEM103.corp.hds.com>
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

>  With this patch, efi_pstore can hold multiple logs with a new kernel parameter, efi_pstore_log_num.

How big a value for efi_pstore_log_num have you tried? Did you see any problems with EFI running
out of space? Do you get some helpful error message if you pick a number that is too big?

-Tony
