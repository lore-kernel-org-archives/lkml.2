Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab2AQTOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 14:14:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:19012 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440Ab2AQTOh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 14:14:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="99666015"
From: "Luck, Tony" <tony.luck@intel.com>
To: Len Brown <lenb@kernel.org>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Chen Gong <gong.chen@linux.intel.com>
Subject: RE: [PATCH] acpi/apei/einj: Add extensions to EINJ from rev 5.0 of
 acpi spec
Thread-Topic: [PATCH] acpi/apei/einj: Add extensions to EINJ from rev 5.0 of
 acpi spec
Thread-Index: AQHM1Ri/Yh+MLXk+5EaQRwUucjIPRJYQ7Y0A
Date: Tue, 17 Jan 2012 19:14:35 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F01CB41@ORSMSX104.amr.corp.intel.com>
References: <212c4cabb390880e855be9509e7d2be002699907.1325716284.git.tony.luck@intel.com>
 <4F157233.2010503@kernel.org>
In-Reply-To: <4F157233.2010503@kernel.org>
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

> drivers/acpi/apei/einj.c:256:3: error: implicit declaration of function 'readq' [-Werror=implicit-function-declaration]

Ah - einj.c has a special version of writeq ... I guess it needs a "readq" too.

I'll respin the patch (needs to fix a typo and add some Examples to the Documentation,
plus fix a line too long for checkpatch).

-Tony
