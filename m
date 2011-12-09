Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab1LISkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:40:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:12377 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab1LISkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:40:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100570015"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: LKML <linux-kernel@vger.kernel.org>, X86-ML <x86@kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>
Date: Fri, 9 Dec 2011 10:40:10 -0800
Subject: RE: [PATCH 2/2] x86, MCE: Drain mcelog buffer
Thread-Topic: [PATCH 2/2] x86, MCE: Drain mcelog buffer
Thread-Index: Acy2n9tTx9DBIZ4hQiaIXbhqItIcwgAAbEvA
Message-ID: <0207C53569FE594381A4F2EB66570B2A018EFB77AE@orsmsx508.amr.corp.intel.com>
References: <1323353332-5671-1-git-send-email-bp@amd64.org>
 <1323353332-5671-3-git-send-email-bp@amd64.org>
 <0207C53569FE594381A4F2EB66570B2A018EFB7762@orsmsx508.amr.corp.intel.com>
 <20111209182448.GA29629@gere.osrc.amd.com>
In-Reply-To: <20111209182448.GA29629@gere.osrc.amd.com>
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

> Do you see a usecase for multiple consumers?

Only a theoretical one ... we might have a cpu model specific decoder
and an OEM supplied platform decoder - each as an independent module.

-Tony
