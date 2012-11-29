Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab2K2WmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 17:42:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:37977 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab2K2WmA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:42:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,188,1355126400"; 
   d="scan'208";a="249478932"
From: "Luck, Tony" <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Mel Gorman <mgorman@suse.de>
CC: Jiang Liu <jiang.liu@huawei.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rob@landley.net" <rob@landley.net>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "wency@cn.fujitsu.com" <wency@cn.fujitsu.com>,
        "linfeng@cn.fujitsu.com" <linfeng@cn.fujitsu.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Wang, Frank" <frank.wang@intel.com>
Subject: RE: [PATCH v2 0/5] Add movablecore_map boot option
Thread-Topic: [PATCH v2 0/5] Add movablecore_map boot option
Thread-Index: AQHNzUWLbzufafl3KEuH3pSKrF3YJJf/w9zAgACJM4CAAOARgIAAVZyA///nswA=
Date: Thu, 29 Nov 2012 22:41:44 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1C95FC11@ORSMSX108.amr.corp.intel.com>
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com>
 <50B5CFAE.80103@huawei.com>
 <3908561D78D1C84285E8C5FCA982C28F1C95EDCE@ORSMSX108.amr.corp.intel.com>
 <50B68467.5020008@zytor.com> <20121129110045.GX8218@suse.de>
 <50B7882D.5060100@zytor.com>
In-Reply-To: <50B7882D.5060100@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The other bit is that if you really really want high reliability, memory
> mirroring is the way to go; it is the only way you will be able to
> hotremove memory without having to have a pre-event to migrate the
> memory away from the affected node before the memory is offlined.

Some platforms don't support cross-node mirrors ... but we still want to
be able to remove a node.

-Tony
