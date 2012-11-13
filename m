Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab2KMSnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:43:13 -0500
Received: from mga14.intel.com ([143.182.124.37]:20601 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413Ab2KMSnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:43:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,768,1344236400"; 
   d="scan'208";a="217238092"
From: "Luck, Tony" <tony.luck@intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>,
        "anton.vorontsov@linaro.org" <anton.vorontsov@linaro.org>,
        "mikew@google.com" <mikew@google.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [PATCH v5 0/7] efi_pstore: multiple event logging support
Thread-Topic: [PATCH v5 0/7] efi_pstore: multiple event logging support
Thread-Index: Ac3Bu6/pJC77FKD1S1qBOAAnxG76oAAEq7rA
Date: Tue, 13 Nov 2012 18:43:08 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D5F3A0@ORSMSX108.amr.corp.intel.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D4138C155D@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D4138C155D@USINDEM103.corp.hds.com>
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

v4 -> v5
   - Rebase to 3.7-rc5
   - Add count to an argument of a write callback executed in pstore_console_write()
     to build successfully in case where CONSIG_PSTORE_CONSOLE=y is specified. (Patch 5/7)

Applied. It's in my
   git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git next
tree now so should pick up into linux-next by tomorrow or the day after.

-Tony
