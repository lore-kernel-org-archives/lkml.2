Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429Ab1BKXJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 18:09:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:21774 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758291Ab1BKXJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 18:09:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,458,1291622400"; 
   d="scan'208";a="886748584"
From: "Hefty, Sean" <sean.hefty@intel.com>
To: Jesper Juhl <jj@chaosbits.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Eli Cohen <eli@mellanox.co.il>, Julia Lawall <julia@diku.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Roland Dreier <roland@kernel.org>
Date: Fri, 11 Feb 2011 15:09:03 -0800
Subject: RE: [PATCH][RFC] infiniband: Fix allocation size in
 register_snoop_agent()
Thread-Topic: [PATCH][RFC] infiniband: Fix allocation size in
 register_snoop_agent()
Thread-Index: AcvKNPcJJWPtu8RbTka2yqhlId2o+QAC01kg
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC45047A@orsmsx501.amr.corp.intel.com>
References: <alpine.LNX.2.00.1102112237490.16994@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1102112237490.16994@swampdragon.chaosbits.net>
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

> Ok, someone needs to double check me on this before merging anything, but
> don't we want to allocate sizeof(struct ib_mad_snoop_private) here, rather
> than just the size of a pointer to the struct?

new_snoop_table is declared as:

struct ib_mad_snoop_private **new_snoop_table;

It should point to an array of pointers.

- Sean
