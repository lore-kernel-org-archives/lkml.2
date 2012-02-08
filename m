Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677Ab2BHV2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:28:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:57075 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756342Ab2BHV2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:28:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="105432481"
From: "Luck, Tony" <tony.luck@intel.com>
To: Don Zickus <dzickus@redhat.com>
CC: Seiji Aguchi <seiji.aguchi@hds.com>, Chen Gong <gong.chen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "'ak@linux.intel.com'" <ak@linux.intel.com>,
        "'hughd@chromium.org'" <hughd@chromium.org>,
        "'mingo@elte.hu'" <mingo@elte.hu>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC) below
 smp_send_stop()
Thread-Topic: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC)
 below smp_send_stop()
Thread-Index: AQHMy9CqWb3Eal+luUidUg+JrwynPJX+IWHAgAAOOECAAJk+gIAGFpuAgACYuICAASNngIAAuA6AgACm9AD//5HLQIADWlqQgAlb+CWAAVZ7cIAWhOmA///PCcCAAI/TAIAHr4MA//+MswA=
Date: Wed, 8 Feb 2012 21:28:37 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F038F46@ORSMSX104.amr.corp.intel.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C583163B0@USINDEVS01.corp.hds.com>
 <4F0D3A0B.4090709@linux.intel.com> <20120111172544.GS5650@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28FD61F@ORSMSX104.amr.corp.intel.com>
 <32727E9A83EE9A42A1F0906295A3A77B2C78F49973@USINDEVS01.corp.hds.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2DA7B65F2A@USINDEVS01.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F0275EE@ORSMSX104.amr.corp.intel.com>
 <20120203171809.GL5650@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F02B380@ORSMSX104.amr.corp.intel.com>
 <20120203225740.GO5650@redhat.com> <20120208201940.GZ5650@redhat.com>
In-Reply-To: <20120208201940.GZ5650@redhat.com>
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

> If I put together a patch to address this would you be willing to let
> Seiji move the kmsg_dump to below smp_send_stop()?

I'd "Ack" it ... not my decision whether to apply it.

-Tony
