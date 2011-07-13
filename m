Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab1GMSBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 14:01:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:54088 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755612Ab1GMSBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 14:01:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,526,1304319600"; 
   d="scan'208";a="29943889"
From: "Luck, Tony" <tony.luck@intel.com>
To: Glauber Costa <glommer@redhat.com>, Avi Kivity <avi@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        "Dong, Eddie" <eddie.dong@intel.com>, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Date: Wed, 13 Jul 2011 11:01:45 -0700
Subject: RE: [PATCH v5 6/9] add jump labels for ia64 paravirt
Thread-Topic: [PATCH v5 6/9] add jump labels for ia64 paravirt
Thread-Index: Acw/zddDqhtLwSJVRhaWsBDRIDvuiwBuHFvA
Message-ID: <987664A83D2D224EAE907B061CE93D5301E9C9F45D@orsmsx505.amr.corp.intel.com>
References: <1309793548-16714-1-git-send-email-glommer@redhat.com>
 <1309793548-16714-7-git-send-email-glommer@redhat.com>
 <4E1AF612.7040103@redhat.com> <4E1AF970.8030109@redhat.com>
In-Reply-To: <4E1AF970.8030109@redhat.com>
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

The paravirt/xen bits in ia64 are already in bit-rot.  I have this
build error in upstream building the arch/ia64/configs/xen_domu_defconfig
(even before applying your latest patch):

drivers/xen/grant-table.c: In function 'gnttab_map_refs':
drivers/xen/grant-table.c:491: error: implicit declaration of function 'm2p_add_override'
drivers/xen/grant-table.c: In function 'gnttab_unmap_refs':
drivers/xen/grant-table.c:514: error: implicit declaration of function 'm2p_remove_override'

Does anyone still care about virtualization support in ia64?

-Tony
