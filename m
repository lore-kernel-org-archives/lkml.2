Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab0DNPBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:01:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:48275 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744Ab0DNPBi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:01:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,204,1270450800"; 
   d="scan'208";a="613045086"
From: "Tung, Chien Tin" <chien.tin.tung@intel.com>
To: Amir Vadai <amirv@mellanox.co.il>,
       Andrea Gozzelino <Andrea.Gozzelino@lnl.infn.it>
CC: Steve Wise <swise@opengridcomputing.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
       "rolandd@cisco.com" <rolandd@cisco.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "pavel@ucw.cz" <pavel@ucw.cz>, "mingo@elte.hu" <mingo@elte.hu>,
       Eric B Munson <ebmunson@us.ibm.com>
Date: Wed, 14 Apr 2010 08:01:35 -0700
Subject: RE: Socket Direct Protocol: help (2)
Thread-Topic: Socket Direct Protocol: help (2)
Thread-Index: Acrb4UUEUDGxJIVxQeGXLjO9r6wGMAAAgtkg
Message-ID: <2EFBCAEF10980645BBCFB605689E08E9047C79B918@azsmsx506.amr.corp.intel.com>
References: <13381_1271060138_o3C8FUH8013968_2977669.1271060085255.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
	<1246722.1271082830120.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
	<2EFBCAEF10980645BBCFB605689E08E9047C7402DA@azsmsx506.amr.corp.intel.com>
	<4BC49E2B.3000804@opengridcomputing.com>
	<2EFBCAEF10980645BBCFB605689E08E9047C7405A0@azsmsx506.amr.corp.intel.com>
	<4BC4D22A.6020700@opengridcomputing.com>
	<2EFBCAEF10980645BBCFB605689E08E9047C7405E9@azsmsx506.amr.corp.intel.com>
	<7037536.1271235105513.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
	<4BC5D1D3.3020004@mellanox.co.il> <4BC5D529.1060701@mellanox.co.il>
In-Reply-To: <4BC5D529.1060701@mellanox.co.il>
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

>One more thing - Please open a bug regarding the num_sge limitation at:
>https://bugs.openfabrics.org/

Done, Bug 2027.

Chien
