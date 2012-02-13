Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab2BMXGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 18:06:20 -0500
Received: from mga14.intel.com ([143.182.124.37]:4036 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab2BMXGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 18:06:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="106385030"
From: "Luck, Tony" <tony.luck@intel.com>
To: Chen Gong <gong.chen@linux.intel.com>, Jiang Liu <liuj97@gmail.com>
CC: "Brown, Len" <len.brown@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: RE: [PATCH] acpi/apei/einj: Add extensions to EINJ from rev 5.0 of
 acpi spec
Thread-Topic: [PATCH] acpi/apei/einj: Add extensions to EINJ from rev 5.0 of
 acpi spec
Thread-Index: AQHM6WlTkHgxr9UiIU6rajNKVjr4pZY6oIYAgADT9BA=
Date: Mon, 13 Feb 2012 23:06:02 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F03B27C@ORSMSX104.amr.corp.intel.com>
References: <1e89d444cd527f11ff9c24ccca741a25cfab3962.1326831060.git.tony.luck@intel.com>
 <4F37874F.4010107@gmail.com> <4F387460.8090506@linux.intel.com>
In-Reply-To: <4F387460.8090506@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1DN6PCj005284

> I'm a little confused about the ACPI_EINJ_SET_ERROR_TYPE_WITH_ADDRESS command in ACPI5.
> The above code seems like a hard-coded version of
> apei_exec_run(&ctx, ACPI_EINJ_SET_ERROR_TYPE_WITH_ADDRESS).

If I mashed this code into the wrong place ... then help me understand how it
should fit in stylistically with the existing code.

Basic summary is that ACPI 5 added the _WITH_ADDRESS functionality. If it is present,
then there seems no point in using the old SET_ERROR_TYPE action from ACPI4.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
