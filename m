Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab2DXDEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 23:04:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:28536 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376Ab2DXDEJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 23:04:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="135921026"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>
Subject: RE: [PATCH 2/2] Enter 2nd kernel with BSP
Thread-Topic: [PATCH 2/2] Enter 2nd kernel with BSP
Thread-Index: AQHNIT65ITP0DIVx9kuGF0QFOk7QwZapsD8A//+azcA=
Date: Tue, 24 Apr 2012 03:04:08 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C71220076F2AE3@ORSMSX105.amr.corp.intel.com>
References: <20120416021951.9303.58568.stgit@localhost6.localdomain6>
	<20120416022139.9303.56284.stgit@localhost6.localdomain6>
	<m2ipgqoh90.fsf@firstfloor.org>
 <20120424.110518.434300178.d.hatayama@jp.fujitsu.com>
In-Reply-To: <20120424.110518.434300178.d.hatayama@jp.fujitsu.com>
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

> >> Split logic into BSP's and AP's: BSP waits for AP halting.
> >>
> >> Don't remove variable crashing_cpu for debugging use; useful for
> >> determining one what CPU crash happens.
> >
> > Fenghua has this patchkit to allow offlining the BSP. What happens
> then?

I'm fixing one issue when doing stress BSP online/offline test. I'll send out a newer patch set pretty soon.

Thanks.

-Fenghua
