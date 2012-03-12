Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2CLRDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:03:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:47744 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab2CLRDt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:03:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="120217496"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>, Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "Mark A. Grondona" <mgrondona@llnl.gov>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/6] Add a per-dimm structure
Thread-Topic: [PATCH 0/6] Add a per-dimm structure
Thread-Index: AQHM/FddfomqTKVEK0avk4xnskAx5pZhekcAgADS+wCAAESmAIAAIlQAgAAjXoCAABCUgIACij2AgAAQXACAAdcwgP//kMVw
Date: Mon, 12 Mar 2012 17:03:47 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F15B61A34@ORSMSX103.amr.corp.intel.com>
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
 <20120308215716.GA5925@aftab> <4F59DC38.5080104@redhat.com>
 <20120309143806.GA11962@aftab> <4F5A329A.70702@redhat.com>
 <20120309184733.GB13745@aftab> <4F5A5E2D.4090408@redhat.com>
 <20120311113411.GB29175@aftab> <4F5C9B6C.2080904@redhat.com>
 <20120312163911.GC7255@aftab>
In-Reply-To: <20120312163911.GC7255@aftab>
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

> Err, the fact that you have UE counters doesn't have anything to do with
> the request that you want to panic on an UE. Especially if conservative
> systems would panic on the first UE anyway without asking software.

We have some UE events for which even a conservative system might
think it reasonable to defer the panic (e.g. patrol scrub on a "free" page).

-Tony
